// Downsample FASTQ files

process downsample {
    container 'quay.io/biocontainers/seqtk:1.4--he4a0461_1'

    input:
    tuple val(meta), path(reads)

    when:
    params.downsample_num

    output:
    tuple val(meta), path("${meta.name}_downsample_*.fastq.gz"), emit: reads

    script:
    if (meta.single_end) {
        """
        readnum=\$((\$(zcat ${reads[0]} | wc -l) / 4))
        if ((\$readnum > $params.downsample_num))
        then
        seqtk sample -s1000 ${reads[0]} $params.downsample_num > ${meta.name}_downsample_R1.fastq
        gzip ${meta.name}_downsample_R1.fastq
        else
        [ ! -f ${meta.name}_downsample_R1.fastq.gz ] && ln -s ${reads[0]} ${meta.name}_downsample_R1.fastq.gz
        fi
        """
    } else {
        """
        readnum=\$((\$(zcat ${reads[0]} | wc -l) / 4))
        if ((\$readnum > $params.downsample_num))
        then
        seqtk sample -s1000 ${reads[0]} $params.downsample_num > ${meta.name}_downsample_R1.fastq
        gzip ${meta.name}_downsample_R1.fastq
        seqtk sample -s1000 ${reads[1]} $params.downsample_num > ${meta.name}_downsample_R2.fastq
        gzip ${meta.name}_downsample_R2.fastq
        else
        [ ! -f ${meta.name}_downsample_R1.fastq.gz ] && ln -s ${reads[0]} ${meta.name}_downsample_R1.fastq.gz
        [ ! -f ${meta.name}_downsample_R2.fastq.gz ] && ln -s ${reads[1]} ${meta.name}_downsample_R2.fastq.gz
        fi
        """
    }
}