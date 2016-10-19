#!/usr/bin/env python
"""The driver program for generating DMR++ XML files."""
import argparse
from urllib.request import Request, urlopen
from pathlib import Path
from lxml import etree
from dmrpp import dmrpp


parser = argparse.ArgumentParser(
    description='Driver program for generating DMR++ files from a Hyrax URL',
    epilog='Developed under the NASA/Raytheon EED-2 Task 28 contract.',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('catalog', type=str, help='URL to THREDDS catalog')
parser.add_argument('inpd', help='Directory to HDF5 files')
parser.add_argument('outd', help='DMR++ output directory ')
parser.add_argument('-f', '--force', action='store_true',
                    help='Overwrite already existing DMR++ files')
parser.add_argument('--ext', type=str, default='dmrpp.xml',
                    help='DMR++ file extension without the dot')
args = parser.parse_args()

# Sanity checks...
inpd = Path(args.inpd)
outd = Path(args.outd)
if not inpd.is_dir():
    raise IOError('%s not a directory' % inpd)
if not outd.is_dir():
    raise IOError('%s not a directory' % outd)

# Read the THREDDS catalog...
r = Request(args.catalog)
with urlopen(r) as rsp:
    xml = rsp.read()
hyrax = '{}://{}'.format(r.type, r.host)

# Parse the THREDDS catalog...
nsmap = {
    'tds': 'http://www.unidata.ucar.edu/namespaces/thredds/InvCatalog/v1.0'}
cat = etree.fromstring(xml)

# Find the DAP service's base path...
dap_srv = cat.xpath('//tds:service[@serviceType="OPeNDAP"]', namespaces=nsmap)
dap_name = dap_srv[0].attrib['name']
dap_base = dap_srv[0].attrib['base']
if not(dap_name and dap_base):
    raise ValueError('Failed to locate DAP service name and base URL path')

# Find all the files in the catalog for which the DAP service is available...
files = cat.xpath(
    '//tds:access[@serviceName="{}"]/parent::tds:dataset'.format(dap_name),
    namespaces=nsmap)
if len(files) == 0:
    raise ValueError('Found no files in the THREDDS catalog')
else:
    print('Found %d files in the THREDDS catalog' % len(files))

# Iterate over each found file...
for fnode in files:
    url_path = fnode.xpath(
        './tds:access[@serviceName="{}"]/@urlPath'.format(dap_name),
        namespaces=nsmap)

    # HDF5 file name...
    p = Path(url_path[0])
    h5name = inpd.joinpath(p.name)

    # DMR++ output file name...
    dmrpp_file = outd.joinpath(p.name + '.' + args.ext)

    if args.force or not dmrpp_file.exists():
        if not h5name.exists():
            raise IOError('%s not found' % h5name)

        # Get the original DMR...
        dmr_url = hyrax + dap_base + url_path[0] + '.dmr.xml'
        print('Fetching DMR from', dmr_url)
        dmr = urlopen(dmr_url).read()

        # Generate DMR++...
        print('Generating DMR++ for', h5name)
        dmrpp_xml = dmrpp(dmr, h5name)
        with dmrpp_file.open('wt', encoding='utf-8') as f:
            f.write(dmrpp_xml)
        print('DMR++ written to', dmrpp_file)
    else:
        print(dmrpp_file, 'already exists')
