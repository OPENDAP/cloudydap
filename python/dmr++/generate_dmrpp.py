#!/usr/bin/env python
"""
The driver program for generating DMR++ XML for a HDF5 file.

Usage:
    generate_dmrpp.py <DMR file> <HDF5 file>
"""

import sys
from pathlib import Path
from dmrpp import dmrpp

with open(sys.argv[1], 'rb') as f:
    dmr = f.read()

dmrpp_xml = dmrpp(dmr, Path(sys.argv[2]))

dmrpp_file = Path(sys.argv[2]).name + '.dmrpp.xml'
with open(dmrpp_file, 'wt', encoding='utf-8') as f:
    f.write(dmrpp_xml)
print('DMR++ written to', dmrpp_file)
