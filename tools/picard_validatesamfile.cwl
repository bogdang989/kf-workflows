class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - java
  - '-jar'
  - '-Xmx8g'
  - /usr/local/bin/picard.jar
  - ValidateSamFile
inputs:
  - format: 'edam:format_2572'
    id: INPUT
    type: File
    inputBinding:
      position: 0
      prefix: INPUT=
      separate: false
  - default: 2147483647
    id: MAX_OUTPUT
    type: int
    inputBinding:
      position: 0
      prefix: MAX_OUTPUT=
      separate: false
  - default: VERBOSE
    id: MODE
    type: string
    inputBinding:
      position: 0
      prefix: MODE=
      separate: false
  - default: .
    id: TMP_DIR
    type: string
    inputBinding:
      position: 0
      prefix: TMP_DIR=
      separate: false
  - default: STRICT
    id: VALIDATION_STRINGENCY
    type: string
    inputBinding:
      position: 0
      prefix: VALIDATION_STRINGENCY=
      separate: false
outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename + ".metrics")
arguments:
  - position: 0
    prefix: OUTPUT=
    separate: false
    valueFrom: $(inputs.INPUT.basename + ".metrics")
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'quay.io/ncigdc/picard:1'
successCodes:
  - 0
  - 1
'sbg:job':
  inputs:
    INPUT:
      path: /path/to/INPUT.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: INPUT.ext
      nameroot: INPUT
      nameext: .ext
    MAX_OUTPUT: 2
    MODE: MODE-string-value
    TMP_DIR: TMP_DIR-string-value
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
