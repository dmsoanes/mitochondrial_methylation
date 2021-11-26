<h1>Steps used to call methylation from bisulfite-seq reads</h1>
<h3>Software used:</h3>
Trim Galore! (v0.6.4): https://github.com/FelixKrueger/TrimGalore  
Bismark (v0.23.1): https://github.com/FelixKrueger/Bismark

1: Trim reads using trim_galore

    trim_galore --paired -o ../trimmed_reads/ --clip_r1 8 --clip_r2 8 --three_prime_clip_r1 8 --three_prime_clip_r2 8 1A_S9_R1_001.fastq.gz 1A_S9_R2_001.fastq.gz

2: Align reads to GRCh38 genome using Bismark

    bismark --genome ~/Documents/human_reference/GRCh38_bismark -1 1A_S9_R1_001_val_1.fq.gz -2 1A_S9_R2_001_val_2.fq.gz -I 0 -X 2000 --score_min L,0,-0.8 -o ../bismark

3: De-duplicating Bismark alignment BAM file

    deduplicate_bismark --bam 1A_S9_R1_001_val_1_bismark_bt2_pe.bam

4: Run bismark methylation extractor

    bismark_methylation_extractor --gzip --bedGraph --cutoff 10 --CX --buffer_size 30G --cytosine_report --genome_folder ~/Documents/human_reference/GRCh38_bismark --split_by_chromosome -o output 1A_S9_R1_001_val_1_bismark_bt2_pe.deduplicated.bam

