// Run MIQ score 16S code
params.publish_dir = "miqscoreShotgun"

process miqscoreShotgun {
    container 'zymoresearch/miqscoreshotgun:latest'
    publishDir "${params.publish_dir}", mode: 'copy'

    input:
    tuple val(meta), path(reads)

    output:
    path '*.html', emit: report

    script:
    readtype = meta.single_end ? "export MODE='SE'" : "mv ${reads[1]} /data/input/sequence/standard_submitted_R2.fastq"
    """
    export SAMPLENAME=${meta.name}
    mkdir -p /data/input/sequence
    mkdir -p /data/working
    mkdir -p /data/output
    mv ${reads[0]} /data/input/sequence/standard_submitted_R1.fastq
    ${readtype}
    python3 /opt/miqScoreShotgun/analyzeStandardReads.py
    mv /data/output/*.html ./
    """
}
