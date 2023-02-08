// Run MIQ score 16S code
params.publish_dir = "miqscoreShotgun"

process miqscoreShotgun {
    container 'zymoresearch/miqscoreshotgun:latest'
    publishDir "${params.publish_dir}", mode: 'copy'

    input:
    env SAMPLENAME
    path read_1
    path read_2

    output:
    path '*.html', emit: report

    script:
    """
    mkdir -p /data/input/sequence
    mkdir -p /data/working
    mv $read_1 /data/input/sequence/standard_submitted_R1.fastq
    mv $read_2 /data/input/sequence/standard_submitted_R2.fastq
    mkdir -p /data/output
    python3 /opt/miqScoreShotgun/analyzeStandardReads.py
    mv /data/output/*.html ./
    """
}
