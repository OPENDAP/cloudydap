"""
Module for generating DMR++ XML.
"""

from os import SEEK_SET
from pathlib import PurePosixPath
from uuid import uuid4
from hashlib import md5
import h5py
from lxml import etree
from lxml.builder import ElementMaker


def collect_info(fname):
    """Extract dataset storage information from HDF5 file.

    Args:
        fname: HDF5 file name as pathlib.Path.

    Returns:
        A dictionary with HDF5 datasets storage information.
    """
    # Open the HDF5 file for simple byte I/O...
    fb = fname.open('rb')
    if not fb.seekable():
        raise OSError('Byte stream for %s not seekable' % fname)
    fb.seek(0, SEEK_SET)

    storage = dict()

    def _stinfo(objname, obj):
        if isinstance(obj, h5py.Dataset):
            stinfo = obj.storage
            if isinstance(stinfo, h5py.h5d.ContiguousStorageInfo):
                fb.seek(stinfo.file_addr, SEEK_SET)
                byte_stream = fb.read(stinfo.size)
                if len(byte_stream) != stinfo.size:
                    raise IOError(
                        'Read %d bytes instead of %d bytes for %s from %s' %
                        (len(byte_stream), stinfo.size, obj.name, fname))

                storage[obj.name] = {'file_addr': stinfo.file_addr,
                                     'size': stinfo.size,
                                     'uuid': str(uuid4()),
                                     'md5': md5(byte_stream).hexdigest()}
            else:
                chunk_info = list()
                storage[obj.name] = {'chunk_size': obj.chunks,
                                     'filters': obj._filters}
                for si in stinfo:
                    fb.seek(si.file_addr, SEEK_SET)
                    byte_stream = fb.read(si.size)
                    if len(byte_stream) != si.size:
                        raise IOError(
                            'Read %d bytes instead of %d bytes for chunk #%d '
                            'of %s from %s' % (len(byte_stream), si.size,
                                               si.order, obj.name, fname))

                    chunk_info.append({'order': si.order,
                                       'file_addr': si.file_addr,
                                       'size': si.size,
                                       'logical_addr': si.logical_addr,
                                       'uuid': str(uuid4()),
                                       'md5': md5(byte_stream).hexdigest()})

                storage[obj.name]['chunk_info'] = chunk_info

    with h5py.File(str(fname), 'r') as f:
        f.visititems(_stinfo)
    fb.close()

    return storage


def locate_dset(dname, doc, dapns):
    """Find HDF5 dataset's DMR node.

    HDF5 dataset path is translated into an XPath expression which is run
    aganst the supplied DMR XML.

    Args:
        dname: HDF5 dataset full path.
        doc: Parsed DMR XML.
        dapns: DMR's namespace URL.
    """
    parts = PurePosixPath(dname).parts

    namespaces = {'dap': dapns}

    # Find the dataset's group node...
    xpath = '/dap:Dataset'
    for grp in parts[1:-1]:
        xpath += '/dap:Group[@name="{}"]'.format(grp)
    grp_nodes = doc.xpath(xpath, namespaces=namespaces)
    if len(grp_nodes) != 1:
        raise ValueError('XPath "%s" found %d group nodes' %
                         (xpath, len(grp_nodes)))

    # Find the dataset's node...
    xpath = ('(dap:Char | dap:Byte | dap:Int8 | dap:UInt8 | '
             'dap:Int16 | dap:UInt16 | dap:Int32 | dap:UInt32 |'
             'dap:Int64 | dap:UInt64 | dap:Float32 | dap:Float64 |'
             'dap:String)[@name="{}"]'
             .format(parts[-1]))
    dset_nodes = grp_nodes[0].xpath(xpath, namespaces=namespaces)
    if len(dset_nodes) != 1:
        raise ValueError('XPath "%s" found %d variable nodes' %
                         (xpath, len(dset_nodes)))

    return dset_nodes[0]


def dmrpp(xml, h5fname):
    """Generate DMR++ XML.

    Args:
        xml: DMR XML as bytes. It will be used to insert the HDF5 dataset
            storage information.
        h5fname: pathlib.Path object representing an HDF5 file name. Storage
            information for its datasets will be inserted in DMR XML.

    Returns:
        A string containing DMR++ XML.
    """
    # Parse the input DMR...
    dmr = etree.fromstring(xml, parser=etree.XMLParser(remove_blank_text=True))

    # Remove the xml:base attribute from the root...
    if dmr.get('{http://www.w3.org/XML/1998/namespace}base'):
        del dmr.attrib['{http://www.w3.org/XML/1998/namespace}base']

    # Compare the file name in the DMR with the input HDF5 file name...
    if dmr.get('name') != h5fname.name:
        raise ValueError('DMR Dataset name mismatch with HDF5 file name')

    # DMR is version 4?
    if dmr.get('dapVersion') != '4.0':
        raise ValueError('DMR XML is not version 4.0')

    # Collect all HDF5 dataset storage information...
    stinfo = collect_info(h5fname)

    # Declare XML namespaces in use...
    ns = {'dap': 'http://xml.opendap.org/ns/DAP/4.0#',
          'h4': 'http://www.hdfgroup.org/HDF4/XML/schema/HDF4map/1.0.1',
          'xsi': 'http://www.w3.org/2001/XMLSchema-instance'}

    if stinfo:
        # Create shortcuts for the XML elements needed...
        E = ElementMaker(namespace=ns['h4'], nsmap=ns)
        ch = E.chunks
        chds = E.chunkDimensionSizes
        bs = E.byteStream

        # Loop over each HDF5 dataset and insert its storage info into the
        # original DMR...
        for dset_name, dset_info in stinfo.items():
            # Translate dataset's name into an XPath to locate it in the
            # original DMR...
            dset_node = locate_dset(dset_name, dmr, ns['dap'])

            # Insert dataset storage information into its DMR XML...
            if dset_info.get('chunk_size'):
                # Chunked dataset, create the <h4:chunks> element...
                chelem = ch()

                # Compression attributes...
                filters = dset_info.get('filters')
                if filters:
                    comp_type = []
                    for f in filters.keys():
                        if f == 'gzip':
                            comp_type.append('deflate')
                            chelem.set('deflate_level', str(filters['gzip']))
                        else:
                            comp_type.append(f)
                    chelem.set('compressionType', ' '.join(comp_type))

                # Chunk dimension sizes...
                dsize_elem = chds()
                dsize_elem.text = ' '.join(map(str, dset_info['chunk_size']))
                chelem.append(dsize_elem)

                # byteStream element for each chunk...
                for c in dset_info.get('chunk_info', []):
                    pos = '[{}]'.format(','.join(map(str, c['logical_addr'])))
                    chelem.append(
                        bs({'offset': str(c['file_addr']),
                            'nBytes': str(c['size']),
                            'uuid': c['uuid'],
                            'md5': c['md5'],
                            'chunkPositionInArray': pos})
                    )

                # Add all this dataset storage XML to the dataset's DMR node...
                dset_node.append(chelem)

            else:
                # Contiguous dataset
                dset_node.append(
                    bs({'offset': str(dset_info['file_addr']),
                        'nBytes': str(dset_info['size']),
                        'uuid': dset_info['uuid'],
                        'md5': dset_info['md5']})
                )

    # Stringify and return the new DMR++ XML...
    etree.cleanup_namespaces(dmr, top_nsmap=ns)
    return etree.tostring(dmr, pretty_print=True, xml_declaration=True,
                          encoding='UTF-8').decode('utf-8')
