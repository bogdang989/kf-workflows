class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - java
  - '-jar'
  - '-Xmx8G'
  - /usr/local/bin/picard.jar
  - SortSam
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
  - id: OUTPUT
    type: string
    inputBinding:
      position: 0
      prefix: OUTPUT=
      separate: false
  - default: coordinate
    id: SORT_ORDER
    type: string
    inputBinding:
      position: 0
      prefix: SORT_ORDER=
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
  - id: SORTED_OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)
    secondaryFiles:
      - ^.bai
    format: 'edam:format_2572'
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
    OUTPUT: OUTPUT-string-value
    SORT_ORDER: SORT_ORDER-string-value
    TMP_DIR: TMP_DIR-string-value
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
