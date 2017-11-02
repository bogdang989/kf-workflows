class: Workflow
cwlVersion: v1.0
inputs:
  - id: bam_path
    type: File
    'sbg:x': 0
    'sbg:y': 877.5
  - id: db_snp_path
    type: File
    'sbg:x': 1440.738525390625
    'sbg:y': 1340.5
  - id: reference_fasta_path
    type: File
    'sbg:x': 866.096435546875
    'sbg:y': 1084.5
  - id: thread_count
    type: int
    'sbg:x': 866.096435546875
    'sbg:y': 442.5
  - id: uuid
    type: string
    'sbg:x': 0
    'sbg:y': 770.5
outputs:
  - id: picard_markduplicates_output
    outputSource:
      - picard_markduplicates/OUTPUT
    type: File
    'sbg:x': 2732.68798828125
    'sbg:y': 796
  - id: merge_all_sqlite_destination_sqlite
    outputSource:
      - merge_all_sqlite/destination_sqlite
    type: File
    'sbg:x': 3614.65966796875
    'sbg:y': 824
steps:
  - id: samtools_bamtobam
    in:
      - id: INPUT
        source:
          - bam_path
    out:
      - id: OUTPUT
    run: ../../tools/samtools_bamtobam.cwl
    'sbg:x': 136.03125
    'sbg:y': 756.5
  - id: picard_validatesamfile_original
    in:
      - id: INPUT
        source:
          - samtools_bamtobam/OUTPUT
      - id: VALIDATION_STRINGENCY
        default: LENIENT
    out:
      - id: OUTPUT
    run: ../../tools/picard_validatesamfile.cwl
    'sbg:x': 374.859375
    'sbg:y': 682
  - id: picard_validatesamfile_original_to_sqlite
    in:
      - id: bam
        source:
          - bam_path
        valueFrom: $(self.basename)
      - id: input_state
        default: original
      - id: metric_path
        source:
          - picard_validatesamfile_original/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: log
      - id: sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    'sbg:x': 136.03125
    'sbg:y': 877.5
  - id: biobambam_bamtofastq
    in:
      - id: filename
        source:
          - samtools_bamtobam/OUTPUT
    out:
      - id: output_fastq1
      - id: output_fastq2
      - id: output_fastq_o1
      - id: output_fastq_o2
      - id: output_fastq_s
    run: ../../tools/biobambam2_bamtofastq.cwl
    'sbg:x': 374.859375
    'sbg:y': 817
  - id: remove_duplicate_fastq1
    in:
      - id: INPUT
        source:
          - biobambam_bamtofastq/output_fastq1
    out:
      - id: OUTPUT
      - id: METRICS
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter:
      - INPUT
    'sbg:x': 647.68408203125
    'sbg:y': 635.5
  - id: remove_duplicate_fastq2
    in:
      - id: INPUT
        source:
          - biobambam_bamtofastq/output_fastq2
    out:
      - id: OUTPUT
      - id: METRICS
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter:
      - INPUT
    'sbg:x': 647.68408203125
    'sbg:y': 514.5
  - id: remove_duplicate_fastq_o1
    in:
      - id: INPUT
        source:
          - biobambam_bamtofastq/output_fastq_o1
    out:
      - id: OUTPUT
      - id: METRICS
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter:
      - INPUT
    'sbg:x': 647.68408203125
    'sbg:y': 998.5
  - id: remove_duplicate_fastq_o2
    in:
      - id: INPUT
        source:
          - biobambam_bamtofastq/output_fastq_o2
    out:
      - id: OUTPUT
      - id: METRICS
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter:
      - INPUT
    'sbg:x': 647.68408203125
    'sbg:y': 877.5
  - id: remove_duplicate_fastq_s
    in:
      - id: INPUT
        source:
          - biobambam_bamtofastq/output_fastq_s
    out:
      - id: OUTPUT
      - id: METRICS
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter:
      - INPUT
    'sbg:x': 647.68408203125
    'sbg:y': 756.5
  - id: sort_scattered_fastq1
    in:
      - id: INPUT
        source:
          - remove_duplicate_fastq1/OUTPUT
    out:
      - id: OUTPUT
    run: ../../tools/sort_scatter_expression.cwl
    'sbg:x': 866.096435546875
    'sbg:y': 656.5
  - id: sort_scattered_fastq2
    in:
      - id: INPUT
        source:
          - remove_duplicate_fastq2/OUTPUT
    out:
      - id: OUTPUT
    run: ../../tools/sort_scatter_expression.cwl
    'sbg:x': 866.096435546875
    'sbg:y': 549.5
  - id: sort_scattered_fastq_o1
    in:
      - id: INPUT
        source:
          - remove_duplicate_fastq_o1/OUTPUT
    out:
      - id: OUTPUT
    run: ../../tools/sort_scatter_expression.cwl
    'sbg:x': 866.096435546875
    'sbg:y': 977.5
  - id: sort_scattered_fastq_o2
    in:
      - id: INPUT
        source:
          - remove_duplicate_fastq_o2/OUTPUT
    out:
      - id: OUTPUT
    run: ../../tools/sort_scatter_expression.cwl
    'sbg:x': 866.096435546875
    'sbg:y': 870.5
  - id: sort_scattered_fastq_s
    in:
      - id: INPUT
        source:
          - remove_duplicate_fastq_s/OUTPUT
    out:
      - id: OUTPUT
    run: ../../tools/sort_scatter_expression.cwl
    'sbg:x': 866.096435546875
    'sbg:y': 763.5
  - id: bam_readgroup_to_json
    in:
      - id: INPUT
        source:
          - samtools_bamtobam/OUTPUT
      - id: MODE
        valueFrom: lenient
    out:
      - id: OUTPUT
      - id: log
    run: ../../tools/bam_readgroup_to_json.cwl
    'sbg:x': 374.859375
    'sbg:y': 959
  - id: readgroup_json_db
    in:
      - id: json_path
        source:
          - bam_readgroup_to_json/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: log
      - id: output_sqlite
    run: ../../tools/readgroup_json_db.cwl
    scatter:
      - json_path
    'sbg:x': 647.68408203125
    'sbg:y': 1119.5
  - id: merge_readgroup_json_db
    in:
      - id: source_sqlite
        source:
          - readgroup_json_db/output_sqlite
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 866.096435546875
    'sbg:y': 1198.5
  - id: fastqc1
    in:
      - id: INPUT
        source:
          - sort_scattered_fastq1/OUTPUT
      - id: threads
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/fastqc.cwl
    scatter:
      - INPUT
    'sbg:x': 1126.2275390625
    'sbg:y': 121
  - id: fastqc2
    in:
      - id: INPUT
        source:
          - sort_scattered_fastq2/OUTPUT
      - id: threads
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/fastqc.cwl
    scatter:
      - INPUT
    'sbg:x': 1126.2275390625
    'sbg:y': 0
  - id: fastqc_s
    in:
      - id: INPUT
        source:
          - sort_scattered_fastq_s/OUTPUT
      - id: threads
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/fastqc.cwl
    scatter:
      - INPUT
    'sbg:x': 1126.2275390625
    'sbg:y': 242
  - id: fastqc_o1
    in:
      - id: INPUT
        source:
          - sort_scattered_fastq_o1/OUTPUT
      - id: threads
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/fastqc.cwl
    scatter:
      - INPUT
    'sbg:x': 1126.2275390625
    'sbg:y': 484
  - id: fastqc_o2
    in:
      - id: INPUT
        source:
          - sort_scattered_fastq_o2/OUTPUT
      - id: threads
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/fastqc.cwl
    scatter:
      - INPUT
    'sbg:x': 1126.2275390625
    'sbg:y': 363
  - id: fastqc_db1
    in:
      - id: INPUT
        source:
          - fastqc1/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: LOG
      - id: OUTPUT
    run: ../../tools/fastqc_db.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 863.5
  - id: fastqc_db2
    in:
      - id: INPUT
        source:
          - fastqc2/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: LOG
      - id: OUTPUT
    run: ../../tools/fastqc_db.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 742.5
  - id: fastqc_db_s
    in:
      - id: INPUT
        source:
          - fastqc_s/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: LOG
      - id: OUTPUT
    run: ../../tools/fastqc_db.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 984.5
  - id: fastqc_db_o1
    in:
      - id: INPUT
        source:
          - fastqc_o1/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: LOG
      - id: OUTPUT
    run: ../../tools/fastqc_db.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 1226.5
  - id: fastqc_db_o2
    in:
      - id: INPUT
        source:
          - fastqc_o2/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: LOG
      - id: OUTPUT
    run: ../../tools/fastqc_db.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 1105.5
  - id: merge_fastqc_db1_sqlite
    in:
      - id: source_sqlite
        source:
          - fastqc_db1/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 1115
  - id: merge_fastqc_db2_sqlite
    in:
      - id: source_sqlite
        source:
          - fastqc_db2/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 994
  - id: merge_fastqc_db_s_sqlite
    in:
      - id: source_sqlite
        source:
          - fastqc_db_s/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 1236
  - id: merge_fastqc_db_o1_sqlite
    in:
      - id: source_sqlite
        source:
          - fastqc_db_o1/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 1478
  - id: merge_fastqc_db_o2_sqlite
    in:
      - id: source_sqlite
        source:
          - fastqc_db_o2/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 1357
  - id: fastqc_pe_basicstats_json
    in:
      - id: sqlite_path
        source:
          - merge_fastqc_db1_sqlite/destination_sqlite
    out:
      - id: OUTPUT
    run: ../../tools/fastqc_basicstatistics_json.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 945
  - id: fastqc_se_basicstats_json
    in:
      - id: sqlite_path
        source:
          - merge_fastqc_db_s_sqlite/destination_sqlite
    out:
      - id: OUTPUT
    run: ../../tools/fastqc_basicstatistics_json.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 838
  - id: fastqc_o1_basicstats_json
    in:
      - id: sqlite_path
        source:
          - merge_fastqc_db_o1_sqlite/destination_sqlite
    out:
      - id: OUTPUT
    run: ../../tools/fastqc_basicstatistics_json.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 1159
  - id: fastqc_o2_basicstats_json
    in:
      - id: sqlite_path
        source:
          - merge_fastqc_db_o2_sqlite/destination_sqlite
    out:
      - id: OUTPUT
    run: ../../tools/fastqc_basicstatistics_json.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 1052
  - id: decider_bwa_pe
    in:
      - id: fastq_path
        source:
          - sort_scattered_fastq1/OUTPUT
      - id: readgroup_path
        source:
          - bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths
    run: ../../tools/decider_bwa_expression.cwl
    'sbg:x': 1126.2275390625
    'sbg:y': 726
  - id: decider_bwa_se
    in:
      - id: fastq_path
        source:
          - sort_scattered_fastq_s/OUTPUT
      - id: readgroup_path
        source:
          - bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths
    run: ../../tools/decider_bwa_expression.cwl
    'sbg:x': 1126.2275390625
    'sbg:y': 605
  - id: decider_bwa_o1
    in:
      - id: fastq_path
        source:
          - sort_scattered_fastq_o1/OUTPUT
      - id: readgroup_path
        source:
          - bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths
    run: ../../tools/decider_bwa_expression.cwl
    'sbg:x': 1126.2275390625
    'sbg:y': 968
  - id: decider_bwa_o2
    in:
      - id: fastq_path
        source:
          - sort_scattered_fastq_o2/OUTPUT
      - id: readgroup_path
        source:
          - bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths
    run: ../../tools/decider_bwa_expression.cwl
    'sbg:x': 1126.2275390625
    'sbg:y': 847
  - id: bwa_pe
    in:
      - id: fastq1
        source:
          - sort_scattered_fastq1/OUTPUT
      - id: fastq2
        source:
          - sort_scattered_fastq2/OUTPUT
      - id: fasta
        source:
          - reference_fasta_path
      - id: readgroup_json_path
        source:
          - decider_bwa_pe/output_readgroup_paths
      - id: fastqc_json_path
        source:
          - fastqc_pe_basicstats_json/OUTPUT
      - id: thread_count
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/bwa_pe.cwl
    scatter:
      - fastq1
      - fastq2
      - readgroup_json_path
    scatterMethod: dotproduct
    'sbg:x': 1126.2275390625
    'sbg:y': 1280
  - id: bwa_se
    in:
      - id: fastq
        source:
          - sort_scattered_fastq_s/OUTPUT
      - id: fasta
        source:
          - reference_fasta_path
      - id: readgroup_json_path
        source:
          - decider_bwa_se/output_readgroup_paths
      - id: fastqc_json_path
        source:
          - fastqc_se_basicstats_json/OUTPUT
      - id: thread_count
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/bwa_se.cwl
    scatter:
      - fastq
      - readgroup_json_path
    scatterMethod: dotproduct
    'sbg:x': 1126.2275390625
    'sbg:y': 1110
  - id: bwa_o1
    in:
      - id: fastq
        source:
          - sort_scattered_fastq_o1/OUTPUT
      - id: fasta
        source:
          - reference_fasta_path
      - id: readgroup_json_path
        source:
          - decider_bwa_o1/output_readgroup_paths
      - id: fastqc_json_path
        source:
          - fastqc_o1_basicstats_json/OUTPUT
      - id: thread_count
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/bwa_se.cwl
    scatter:
      - fastq
      - readgroup_json_path
    scatterMethod: dotproduct
    'sbg:x': 1126.2275390625
    'sbg:y': 1613
  - id: bwa_o2
    in:
      - id: fastq
        source:
          - sort_scattered_fastq_o2/OUTPUT
      - id: fasta
        source:
          - reference_fasta_path
      - id: readgroup_json_path
        source:
          - decider_bwa_o2/output_readgroup_paths
      - id: fastqc_json_path
        source:
          - fastqc_o2_basicstats_json/OUTPUT
      - id: thread_count
        source:
          - thread_count
    out:
      - id: OUTPUT
    run: ../../tools/bwa_se.cwl
    scatter:
      - fastq
      - readgroup_json_path
    scatterMethod: dotproduct
    'sbg:x': 1126.2275390625
    'sbg:y': 1450
  - id: picard_sortsam_pe
    in:
      - id: INPUT
        source:
          - bwa_pe/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT
    run: ../../tools/picard_sortsam.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 414.5
  - id: picard_sortsam_se
    in:
      - id: INPUT
        source:
          - bwa_se/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT
    run: ../../tools/picard_sortsam.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 307.5
  - id: picard_sortsam_o1
    in:
      - id: INPUT
        source:
          - bwa_o1/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT
    run: ../../tools/picard_sortsam.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 628.5
  - id: picard_sortsam_o2
    in:
      - id: INPUT
        source:
          - bwa_o2/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT
    run: ../../tools/picard_sortsam.cwl
    scatter:
      - INPUT
    'sbg:x': 1440.738525390625
    'sbg:y': 521.5
  - id: metrics_pe
    in:
      - id: bam
        source:
          - picard_sortsam_pe/SORTED_OUTPUT
      - id: db_snp_vcf
        source:
          - db_snp_path
      - id: fasta
        source:
          - reference_fasta_path
      - id: input_state
        valueFrom: sorted_readgroup
      - id: parent_bam
        source:
          - bam_path
        valueFrom: $(self.basename)
      - id: thread_count
        source:
          - thread_count
      - id: uuid
        source:
          - uuid
    out:
      - id: merge_sqlite_destination_sqlite
    run: metrics.cwl
    scatter:
      - bam
    'sbg:x': 1672.972900390625
    'sbg:y': 845
  - id: merge_metrics_pe
    in:
      - id: source_sqlite
        source:
          - metrics_pe/merge_sqlite_destination_sqlite
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 724
  - id: metrics_se
    in:
      - id: bam
        source:
          - picard_sortsam_se/SORTED_OUTPUT
      - id: db_snp_vcf
        source:
          - db_snp_path
      - id: fasta
        source:
          - reference_fasta_path
      - id: input_state
        valueFrom: sorted_readgroup
      - id: parent_bam
        source:
          - bam_path
        valueFrom: $(self.basename)
      - id: thread_count
        source:
          - thread_count
      - id: uuid
        source:
          - uuid
    out:
      - id: merge_sqlite_destination_sqlite
    run: metrics.cwl
    scatter:
      - bam
    'sbg:x': 1672.972900390625
    'sbg:y': 668
  - id: merge_metrics_se
    in:
      - id: source_sqlite
        source:
          - metrics_se/merge_sqlite_destination_sqlite
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 603
  - id: picard_mergesamfiles_pe
    in:
      - id: INPUT
        source:
          - picard_sortsam_pe/SORTED_OUTPUT
      - id: OUTPUT
        source:
          - bam_path
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT
    run: ../../tools/picard_mergesamfiles.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 277
  - id: picard_mergesamfiles_se
    in:
      - id: INPUT
        source:
          - picard_sortsam_se/SORTED_OUTPUT
      - id: OUTPUT
        source:
          - bam_path
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT
    run: ../../tools/picard_mergesamfiles.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 156
  - id: picard_mergesamfiles_o1
    in:
      - id: INPUT
        source:
          - picard_sortsam_o1/SORTED_OUTPUT
      - id: OUTPUT
        source:
          - bam_path
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT
    run: ../../tools/picard_mergesamfiles.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 519
  - id: picard_mergesamfiles_o2
    in:
      - id: INPUT
        source:
          - picard_sortsam_o2/SORTED_OUTPUT
      - id: OUTPUT
        source:
          - bam_path
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT
    run: ../../tools/picard_mergesamfiles.cwl
    'sbg:x': 1672.972900390625
    'sbg:y': 398
  - id: picard_mergesamfiles
    in:
      - id: INPUT
        source:
          - picard_mergesamfiles_pe/MERGED_OUTPUT
          - picard_mergesamfiles_se/MERGED_OUTPUT
          - picard_mergesamfiles_o1/MERGED_OUTPUT
          - picard_mergesamfiles_o2/MERGED_OUTPUT
      - id: OUTPUT
        source:
          - bam_path
        valueFrom: '$(self.basename.slice(0,-4) + "_gdc_realn.bam")'
    out:
      - id: MERGED_OUTPUT
    run: ../../tools/picard_mergesamfiles.cwl
    'sbg:x': 2062.20703125
    'sbg:y': 482
  - id: bam_reheader
    in:
      - id: bam_path
        source:
          - picard_mergesamfiles/MERGED_OUTPUT
    out:
      - id: output_bam
      - id: log
    run: ../../tools/bam_reheader.cwl
    'sbg:x': 2322.33837890625
    'sbg:y': 817
  - id: picard_markduplicates
    in:
      - id: INPUT
        source:
          - bam_reheader/output_bam
    out:
      - id: OUTPUT
      - id: METRICS
    run: ../../tools/picard_markduplicates.cwl
    'sbg:x': 2540.55224609375
    'sbg:y': 817
  - id: picard_markduplicates_to_sqlite
    in:
      - id: bam
        source:
          - picard_markduplicates/OUTPUT
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: markduplicates_readgroups
      - id: metric_path
        source:
          - picard_markduplicates/METRICS
      - id: uuid
        source:
          - uuid
    out:
      - id: log
      - id: sqlite
    run: ../../tools/picard_markduplicates_to_sqlite.cwl
    'sbg:x': 2732.68798828125
    'sbg:y': 675
  - id: picard_validatesamfile_markduplicates
    in:
      - id: INPUT
        source:
          - picard_markduplicates/OUTPUT
      - id: VALIDATION_STRINGENCY
        valueFrom: STRICT
    out:
      - id: OUTPUT
    run: ../../tools/picard_validatesamfile.cwl
    'sbg:x': 2732.68798828125
    'sbg:y': 554
  - id: picard_validatesamfile_markdupl_to_sqlite
    in:
      - id: bam
        source:
          - bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: markduplicates_readgroups
      - id: metric_path
        source:
          - picard_validatesamfile_markduplicates/OUTPUT
      - id: uuid
        source:
          - uuid
    out:
      - id: log
      - id: sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    'sbg:x': 3109.5595703125
    'sbg:y': 810
  - id: metrics_markduplicates
    in:
      - id: bam
        source:
          - picard_markduplicates/OUTPUT
      - id: db_snp_vcf
        source:
          - db_snp_path
      - id: fasta
        source:
          - reference_fasta_path
      - id: input_state
        valueFrom: markduplicates_readgroups
      - id: thread_count
        source:
          - thread_count
      - id: uuid
        source:
          - uuid
    out:
      - id: merge_sqlite_destination_sqlite
    run: mixed_library_metrics.cwl
    'sbg:x': 2732.68798828125
    'sbg:y': 931
  - id: integrity
    in:
      - id: bai_path
        source:
          - picard_markduplicates/OUTPUT
        valueFrom: '$(self.secondaryFiles[0])'
      - id: bam_path
        source:
          - picard_markduplicates/OUTPUT
      - id: input_state
        default: markduplicates_readgroups
      - id: uuid
        source:
          - uuid
    out:
      - id: merge_sqlite_destination_sqlite
    run: integrity.cwl
    'sbg:x': 2732.68798828125
    'sbg:y': 1080
  - id: merge_all_sqlite
    in:
      - id: source_sqlite
        source:
          - picard_validatesamfile_original_to_sqlite/sqlite
          - picard_validatesamfile_markdupl_to_sqlite/sqlite
          - merge_readgroup_json_db/destination_sqlite
          - merge_fastqc_db1_sqlite/destination_sqlite
          - merge_fastqc_db2_sqlite/destination_sqlite
          - merge_fastqc_db_s_sqlite/destination_sqlite
          - merge_fastqc_db_o1_sqlite/destination_sqlite
          - merge_fastqc_db_o2_sqlite/destination_sqlite
          - merge_metrics_pe/destination_sqlite
          - merge_metrics_se/destination_sqlite
          - metrics_markduplicates/merge_sqlite_destination_sqlite
          - picard_markduplicates_to_sqlite/sqlite
          - integrity/merge_sqlite_destination_sqlite
      - id: uuid
        source:
          - uuid
    out:
      - id: destination_sqlite
      - id: log
    run: ../../tools/merge_sqlite.cwl
    'sbg:x': 3354.5283203125
    'sbg:y': 817
requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
