class: CommandLineTool
cwlVersion: v1.0
baseCommand:
  - bash
  - '-c'
inputs:
  - format: 'edam:format_2182'
    id: fastq
    type: File
  - format: 'edam:format_1929'
    id: fasta
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  - id: readgroup_json_path
    type: File
    inputBinding:
      position: 0
      shellQuote: false
      loadContents: true
  - id: fastqc_json_path
    type: File
    inputBinding:
      position: 0
      shellQuote: false
      loadContents: true
  - id: thread_count
    type: int
outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: '$(inputs.readgroup_json_path.basename.slice(0,-4) + "bam")'
    format: 'edam:format_2572'
arguments:
  - position: 0
    valueFrom: |
      ${
        function to_rg() {
          var readgroup_str = "@RG";
          var readgroup_json = JSON.parse(inputs.readgroup_json_path.contents);
          var keys = Object.keys(readgroup_json).sort();
          for (var i = 0; i < keys.length; i++) {
            var key = keys[i];
            var value = readgroup_json[key];
            readgroup_str = readgroup_str + "\\t" + key + ":" + value;
          }
          return readgroup_str
        }

        function bwa_aln_33(rg_str, outbam) {
          var cmd = [
          "bwa", "aln", "-t", inputs.thread_count, inputs.fasta.path, inputs.fastq.path, ">", "aln.sai", "&&",
          "bwa", "samse", "-r", "\"" + rg_str + "\"", inputs.fasta.path, "aln.sai", inputs.fastq.path, "|",
          "samtools", "view", "-Shb", "-o", outbam, "-"
          ];
          return cmd.join(' ')
        }

        function bwa_aln_64(rg_str, outbam) {
          var cmd = [
          "bwa", "aln", "-I","-t", inputs.thread_count, inputs.fasta.path, inputs.fastq.path, ">", "aln.sai", "&&",
          "bwa", "samse", "-r", "\"" + rg_str + "\"", inputs.fasta.path, "aln.sai", inputs.fastq.path, "|",
          "samtools", "view", "-Shb", "-o", outbam, "-"
          ];
          return cmd.join(' ')
        }

        function bwa_mem(rg_str, outbam) {
          var cmd = [
          "bwa", "mem", "-t", inputs.thread_count, "-T", "0", "-R", "\"" + rg_str + "\"",
          inputs.fasta.path, inputs.fastq.path, "|",
          "samtools", "view", "-Shb", "-o", outbam, "-"
          ];
          return cmd.join(' ')
        }

        var MEM_ALN_CUTOFF = 70;
        var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);
        var readlength = fastqc_json[inputs.fastq.basename]["Sequence length"];
        var encoding = fastqc_json[inputs.fastq.basename]["Encoding"];
        var rg_str = to_rg();

        var outbam = inputs.readgroup_json_path.basename.slice(0,-4) + "bam";

        if (encoding == "Illumina 1.3" || encoding == "Illumina 1.5") {
          return bwa_aln_64(rg_str, outbam)
        } else if (encoding == "Sanger / Illumina 1.9") {
          if (readlength < MEM_ALN_CUTOFF) {
            return bwa_aln_33(rg_str, outbam)
          }
          else {
            return bwa_mem(rg_str, outbam)
          }
        } else {
          return
        }

      }
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: $(inputs.thread_count*7)
    coresMin: $(inputs.thread_count)
  - class: DockerRequirement
    dockerPull: 'quay.io/ncigdc/bwa:1'
'sbg:job':
  inputs:
    fastq:
      basename: fastq.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: fastq
      path: /path/to/fastq.ext
      secondaryFiles: []
      size: 0
    fasta:
      basename: fasta.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: fasta
      path: /path/to/fasta.ext
      secondaryFiles: []
      size: 0
    readgroup_json_path:
      basename: readgroup_json_path.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: readgroup_json_path
      path: /path/to/readgroup_json_path.ext
      secondaryFiles: []
      size: 0
    fastqc_json_path:
      basename: fastqc_json_path.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: fastqc_json_path
      path: /path/to/fastqc_json_path.ext
      secondaryFiles: []
      size: 0
    thread_count: 2
  runtime:
    cores: 1
    ram: 1000
