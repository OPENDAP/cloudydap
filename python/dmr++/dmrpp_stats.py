#!/usr/bin/env python
"""
The driver program for generating DMR++ XML for a HDF5 file.

Usage:
    generate_dmrpp.py <DMR file> <HDF5 file>
"""

import sys
import argparse
from pathlib import Path
from dmrpp import collect_bytestream_info
import csv


def log(*msg):
    if arg.verbose:
        print(*msg)


parser = argparse.ArgumentParser(
    description='Collect dataset storage information from DMR++ files.',
    epilog='Developed under the NASA/Raytheon EED-2 Task 28 contract.',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('csvfile', help='Output CSV file for parsed information')
parser.add_argument('--dir', help='Directory with DMR++ files.',
                    default=Path().cwd())
parser.add_argument('--ext', help='DMR++ file extension.', default='dmrpp.xml')
parser.add_argument('-r', '--recursive',
                    help='Recursively search subdirectories.',
                    action='store_true', default=False)
parser.add_argument('-v', '--verbose', help='Verbose output',
                    action='store_true', default=False)
arg = parser.parse_args()


# Deal with the leading dot in DMR++ file extension...
if not arg.ext.startswith('.'):
    arg.ext = '.' + arg.ext

log('DMR++ file directory {}'.format(arg.dir))

# Find DMR++ files...
if arg.recursive:
    log('\t...will recursively search subdirectories')
    dmrpp_files = list(Path(arg.dir).joinpath(arg.dir).glob('**/*' + arg.ext))
else:
    dmrpp_files = list(Path(arg.dir).joinpath(arg.dir).glob('*' + arg.ext))

if len(dmrpp_files):
    log('Found {} DMR++ files.'.format(len(dmrpp_files)))
    csvfile = Path(arg.csvfile)
    if not csvfile.exists():
        columns = ['File', 'Dataset', 'Chunk_Flag', 'UUID', 'MD5', 'Offset',
                   'Size']
        with csvfile.open('w', newline='') as f:
            csv.writer(f).writerow(columns)
    log('Store dataset storage information in this CSV file: {}'
        .format(csvfile.resolve()))
else:
    log('No DMR++ files found')
    sys.exit()

# Process found DMR++ files...
for df in dmrpp_files:
    log('Processing {}'.format(df))
    with df.open('rb') as f:
        dmrpp_xml = f.read()

    stats = collect_bytestream_info(dmrpp_xml)

    entries = list()
    if 'h5file' not in stats:
        log('No HDF5 file name in DMR++ stats. Skipping...')
        continue
    elif 'datasets' not in stats:
        log('No "datasets" in the DMR++ stats for "{}". Skipping...'
            .format(stats['h5file']))
        continue

    # Loop over all datasets found in the DMR++...
    for dset in stats['datasets']:
        # Loop over all dataset's byte streams...
        dset_stats = stats['datasets'][dset].get('byteStreams', {})
        for uuid, bst in dset_stats.items():
            entries.append(
                [stats['h5file'],
                 dset,
                 stats['datasets'][dset]['chunked'],
                 uuid,
                 bst['md5'],
                 bst['offset'],
                 bst['size']]
            )

    # Write the file stats to output file...
    if entries:
        with csvfile.open('a', newline='') as f:
            w = csv.writer(f)
            w.writerows(entries)
            f.flush()
# dmrpp_file = Path(sys.argv[2]).name + '.dmrpp.xml'
# with open(dmrpp_file, 'wt', encoding='utf-8') as f:
#     f.write(dmrpp_xml)
# print('DMR++ written to', dmrpp_file)
