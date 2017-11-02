class: CommandLineTool
cwlVersion: v1.0
baseCommand: []
inputs:
  - default: false
    id: ASSUME_SORTED
    type: boolean
    inputBinding:
      position: 0
      prefix: ASSUME_SORTED=
      separate: false
  - default: 'true'
    id: CREATE_INDEX
    type: string
    inputBinding:
      position: 0
      prefix: CREATE_INDEX=
      separate: false
  - format: 'edam:format_2572'
    id: INPUT
    type: 'File[]'
  - id: INTERVALS
    type: File?
    inputBinding:
      position: 0
      prefix: INTERVALS=
      separate: false
  - default: 'false'
    id: MERGE_SEQUENCE_DICTIONARIES
    type: string
    inputBinding:
      position: 0
      prefix: MERGE_SEQUENCE_DICTIONARIES=
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
  - default: 'true'
    id: USE_THREADING
    type: string
    inputBinding:
      position: 0
      prefix: USE_THREADING=
      separate: false
  - default: STRICT
    id: VALIDATION_STRINGENCY
    type: string
    inputBinding:
      position: 0
      prefix: VALIDATION_STRINGENCY=
      separate: false
outputs:
  - id: MERGED_OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)
arguments:
  - position: 0
    prefix: ''
    valueFrom: |
      ${
        if (inputs.INPUT.length == 0) {
          var cmd = ['/usr/bin/touch', inputs.OUTPUT];
          return cmd
        }
        else {
          var cmd = ["java", "-jar", "-Xmx8G", "/usr/local/bin/picard.jar", "MergeSamFiles"];
          var use_input = [];
          for (var i = 0; i < inputs.INPUT.length; i++) {
            var filesize = inputs.INPUT[i].size;
            if (filesize > 0) {
              use_input.push("INPUT=" + inputs.INPUT[i].path);
            }
          }

          var run_cmd = cmd.concat(use_input);
          return run_cmd
        }

      }
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'quay.io/ncigdc/picard:1'
'sbg:job':
  inputs:
    ASSUME_SORTED: true
    CREATE_INDEX: CREATE_INDEX-string-value
    INPUT:
      - path: /path/to/INPUT-1.ext
        class: File
        size: 0
        contents: file contents
        secondaryFiles: []
      - path: /path/to/INPUT-2.ext
        class: File
        size: 0
        contents: file contents
        secondaryFiles: []
    INTERVALS:
      path: /path/to/INTERVALS.ext
      class: File
      size: 0
      contents: file contents
      secondaryFiles: []
      basename: INTERVALS.ext
      nameroot: INTERVALS
      nameext: .ext
    MERGE_SEQUENCE_DICTIONARIES: MERGE_SEQUENCE_DICTIONARIES-string-value
    OUTPUT: OUTPUT-string-value
    SORT_ORDER: SORT_ORDER-string-value
    TMP_DIR: TMP_DIR-string-value
    USE_THREADING: USE_THREADING-string-value
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
