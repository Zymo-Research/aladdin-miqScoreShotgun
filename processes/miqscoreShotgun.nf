// Run MIQ score 16S code
params.publish_dir = "miqscoreShotgun"

process miqscoreShotgun {
    container 'zymoresearch/miqscoreshotgun:022525'
    publishDir "${params.publish_dir}", mode: 'copy'

    input:
    tuple val(meta), path(reads)

    output:
    path '*.html', emit: report

    script:
    if (meta.single_end) {
        """
        export SAMPLENAME=${meta.name}
        mv ${reads[0]} standard_submitted_R1.fastq.gz
        export FORWARDREADS=\$PWD/standard_submitted_R1.fastq.gz
        export MODE='SE'
        mkdir output
        export OUTPUTFOLDER=\$PWD/output
        mkdir working
        export WORKINGFOLDER=\$PWD/working
        export SEQUENCEFOLDER=\$PWD
        export LOGFILE=\$PWD/miqcoreshotgun.log
        python3 /opt/miqScoreShotgun/analyzeStandardReads.py
        mv output/*.html ./
        """
    } else {
        """
        export SAMPLENAME=${meta.name}
        mv ${reads[0]} standard_submitted_R1.fastq.gz
        export FORWARDREADS=\$PWD/standard_submitted_R1.fastq.gz
        mv ${reads[1]} standard_submitted_R2.fastq.gz
        export REVERSEREADS=\$PWD/standard_submitted_R2.fastq.gz
        mkdir output
        export OUTPUTFOLDER=\$PWD/output
        mkdir working
        export WORKINGFOLDER=\$PWD/working
        export SEQUENCEFOLDER=\$PWD
        export LOGFILE=\$PWD/miqcoreshotgun.log
        python3 /opt/miqScoreShotgun/analyzeStandardReads.py
        mv output/*.html ./
        """
    }
}
