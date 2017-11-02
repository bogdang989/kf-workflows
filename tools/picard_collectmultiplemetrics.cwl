class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - java
  - '-jar'
  - '-Xmx8G'
  - /usr/local/bin/picard.jar
  - CollectMultipleMetrics
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
  - default: ALL_READS
    id: METRIC_ACCUMULATION_LEVEL=
    type: string
    inputBinding:
      position: 0
      prefix: METRIC_ACCUMULATION_LEVEL=
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
  - default: STRICT
    id: VALIDATION_STRINGENCY
    type: string
    inputBinding:
      position: 0
      prefix: VALIDATION_STRINGENCY=
      separate: false
outputs:
  - id: alignment_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".alignment_summary_metrics")
  - id: bait_bias_detail_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".bait_bias_detail_metrics")
  - id: bait_bias_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".bait_bias_summary_metrics")
  - id: base_distribution_by_cycle_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".base_distribution_by_cycle_metrics")
  - id: base_distribution_by_cycle_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".base_distribution_by_cycle.pdf")
  - id: gc_bias_detail_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".gc_bias.detail_metrics")
  - id: gc_bias_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".gc_bias.pdf")
  - id: gc_bias_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".gc_bias.summary_metrics")
  - id: insert_size_histogram_pdf
    type: File?
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".insert_size_histogram.pdf")
  - id: insert_size_metrics
    type: File?
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".insert_size_metrics")
  - id: pre_adapter_detail_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".pre_adapter_detail_metrics")
  - id: pre_adapter_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".pre_adapter_summary_metrics")
  - id: quality_by_cycle_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_by_cycle_metrics")
  - id: quality_by_cycle_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_by_cycle.pdf")
  - id: quality_distribution_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_distribution_metrics")
  - id: quality_distribution_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_distribution.pdf")
  - id: quality_yield_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_yield_metrics")
arguments:
  - position: 0
    valueFrom: PROGRAM=CollectAlignmentSummaryMetrics
  - position: 0
    valueFrom: PROGRAM=CollectBaseDistributionByCycle
  - position: 0
    valueFrom: PROGRAM=CollectGcBiasMetrics
  - position: 0
    valueFrom: PROGRAM=CollectInsertSizeMetrics
  - position: 0
    valueFrom: PROGRAM=CollectQualityYieldMetrics
  - position: 0
    valueFrom: PROGRAM=CollectSequencingArtifactMetrics
  - position: 0
    valueFrom: PROGRAM=MeanQualityByCycle
  - position: 0
    valueFrom: PROGRAM=QualityScoreDistribution
  - position: 0
    prefix: OUTPUT=
    separate: false
    valueFrom: $(inputs.INPUT.nameroot)
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
    METRIC_ACCUMULATION_LEVEL=: METRIC_ACCUMULATION_LEVEL=-string-value
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
    VALIDATION_STRINGENCY: VALIDATION_STRINGENCY-string-value
  runtime:
    cores: 1
    ram: 8000
