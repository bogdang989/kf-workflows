class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - java
  - '-jar'
  - '-Xmx8G'
  - /usr/local/bin/picard.jar
  - CollectWgsMetrics
inputs:
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
      glob: $(inputs.INPUT.nameroot + ".metrics")
arguments:
  - position: 0
    prefix: OUTPUT=
    separate: false
    valueFrom: $(inputs.INPUT.nameroot + ".metrics")
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'quay.io/ncigdc/picard:1'
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
    REFERENCE_SEQUENCE:
      path: /path/to/REFERENCE_SEQUENCE.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: REFERENCE_SEQUENCE.ext
      nameroot: REFERENCE_SEQUENCE
      nameext: .ext
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
