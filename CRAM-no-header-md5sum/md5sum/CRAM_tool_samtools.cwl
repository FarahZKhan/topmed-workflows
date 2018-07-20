#!/usr/bin/env cwl-runner

class: CommandLineTool
id: CRAM_samtools
label: samtools tool
cwlVersion: v1.0

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

#doc: |
#  [![Docker Repository on Quay.io](https://quay.io/repository/briandoconnor/dockstore-tool-md5sum/status "Docker Repository on Quay.io")](https://quay.io/repository/briandoconnor/dockstore-tool-md5sum)
#  [![Build Status](https://travis-ci.org/briandoconnor/dockstore-tool-md5sum.svg)](https://travis-ci.org/briandoconnor/dockstore-tool-md5sum)
#  A very, very simple Docker container for the md5sum command. See the [README](https://github.com/briandoconnor/dockstore-tool-md5sum/blob/master/README.md) for more information.


#dct:creator:
#  '@id':  https://orcid.org/0000-0001-5173-4627
#  foaf:name: Walter Shands
#  foaf:mbox: jshands@ucsc.edu

requirements:
- class: DockerRequirement
  dockerPull: us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.3.2-1510681135
- class: InlineJavascriptRequirement

hints:
- class: ResourceRequirement
  # The command uses primarily one core but significant disk space.
  coresMin: 1
  ramMin: 1024
  outdirMin: 100000

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.input_file)
      - $(inputs.input_index_file)
      - $(inputs.reference_file)
      - $(inputs.reference_index_file)

inputs:
  reference_file:
    type: File
    inputBinding:
      position: 1
      prefix: -T
    doc: The genome reference file for the BAM or CRAM file.

  reference_index_file:
    type: File
    inputBinding:
      position: 2
      prefix: -t
    doc: The index file for the genome reference file.

  input_index_file:
    type: File
    doc: The index file for the input CRAM or BAM file.

  input_file:
    type: File
    inputBinding:
      position: 3
    doc: The BAM or CRAM file that will be converted to a SAM file with no header.

outputs:
  output_file:
    type: stdout
    format: http://edamontology.org/format_2573
    doc: A SAM file with no header.

stdout: $(inputs.input_file["basename"]).sam
baseCommand: [samtools, view]
