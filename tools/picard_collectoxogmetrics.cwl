class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - java
  - '-jar'
  - '-Xmx8G'
  - /usr/local/bin/picard.jar
  - CollectOxoGMetrics
inputs:
  - format: 'edam:format_3016'
    id: DB_SNP
    type: File
    inputBinding:
      position: 0
      prefix: DB_SNP=
      separate: false
  - format: 'edam:format_2572'
    id: INPUT
    type: File
    inputBinding:
      position: 0
      prefix: INPUT=
      separate: false
  - format: 'edam:format_1929'
    id: REFERENCE_SEQUENCE
    type: File
    inputBinding:
      position: 0
      prefix: REFERENCE_SEQUENCE=
      separate: false
  - default: .
    id: TMP_DIR
    type: string
    inputBinding:
      position: 0
      prefix: TMP_DIR=
      separate: false
  - default: 'true'
    id: USE_OQ
    type: string
    inputBinding:
      position: 0
      prefix: USE_OQ=
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
'sbg:job':
  inputs:
    DB_SNP:
      path: /path/to/DB_SNP.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: DB_SNP.ext
      nameroot: DB_SNP
      nameext: .ext
    INPUT:
      path: /path/to/INPUT.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: INPUT.ext
      nameroot: INPUT
      nameext: .ext
    REFERENCE_SEQUENCE:
      path: /path/to/REFERENCE_SEQUENCE.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: REFERENCE_SEQUENCE.ext
      nameroot: REFERENCE_SEQUENCE
      nameext: .ext
    TMP_DIR: TMP_DIR-string-value
    USE_OQ: USE_OQ-string-value
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
