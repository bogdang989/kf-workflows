class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - java
  - '-jar'
  - '-Xmx8G'
  - /usr/local/bin/picard.jar
  - MarkDuplicates
inputs:
  - default: 'true'
    id: CREATE_INDEX
    type: string
    inputBinding:
      position: 0
      prefix: CREATE_INDEX=
      separate: false
  - format: 'edam:format_2572'
    id: INPUT
    type: File
    inputBinding:
      position: 0
      prefix: INPUT=
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
      glob: $(inputs.INPUT.basename)
    secondaryFiles:
      - ^.bai
    format: 'edam:format_2572'
  - id: METRICS
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename + ".metrics")
arguments:
  - position: 0
    prefix: OUTPUT=
    separate: false
    valueFrom: $(inputs.INPUT.basename)
  - position: 0
    prefix: METRICS_FILE=
    separate: false
    valueFrom: $(inputs.INPUT.basename + ".metrics")
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'quay.io/ncigdc/picard:1'
'sbg:job':
  inputs:
    CREATE_INDEX: CREATE_INDEX-string-value
    INPUT:
      path: /path/to/INPUT.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: INPUT.ext
      nameroot: INPUT
      nameext: .ext
    TMP_DIR: TMP_DIR-string-value
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
