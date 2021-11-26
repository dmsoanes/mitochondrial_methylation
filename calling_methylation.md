<h1>Calling mitochindrial methylation from bisulfite-seq reads</h1>
<h3>Software used:</h3>
<b>Trim Galore! (v0.6.4):</b> https://github.com/FelixKrueger/TrimGalore <br>
<b>Bismark (v0.23.1):</b> https://github.com/FelixKrueger/Bismark <br><br>
<h3>Genome Reference:</h3>
GRCh38 primary assembly: https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.primary_assembly.genome.fa.gz<br><br>
<h3>Analysis steps starting with raw illumina reads:</h3><br>

1: Trim reads using trim_galore (remove adaptor sequence, low quality bases and 8bp from 5' and 3' ends)

    trim_galore --paired -o ../trimmed_reads/ --clip_r1 8 --clip_r2 8 --three_prime_clip_r1 8 --three_prime_clip_r2 8 1A_S9_R1_001.fastq.gz 1A_S9_R2_001.fastq.gz

2: Align reads to GRCh38 genome using Bismark (with Bowtie2)

    bismark --genome ~/Documents/human_reference/GRCh38_bismark -1 1A_S9_R1_001_val_1.fq.gz -2 1A_S9_R2_001_val_2.fq.gz -I 0 -X 2000 --score_min L,0,-0.8 -o ../bismark

3: De-duplicating Bismark alignment BAM file

    deduplicate_bismark --bam 1A_S9_R1_001_val_1_bismark_bt2_pe.bam

4: Run bismark methylation extractor

    bismark_methylation_extractor --gzip --bedGraph --cutoff 10 --CX --buffer_size 30G --cytosine_report --genome_folder ~/Documents/human_reference/GRCh38_bismark --split_by_chromosome -o output 1A_S9_R1_001_val_1_bismark_bt2_pe.deduplicated.bam

This produces a genome-wide cytosine report at both CpG and non-CpG positions for each chromosome. I then copied the mitochondrial genome reports into a separate folder containing the perl script [cytosine_stats.pl](cytosine_stats.pl). Running this script calculates the percentage methylation and coverage at each cytosine for all the files in the directory.
