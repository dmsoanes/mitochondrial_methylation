#!/usr/bin/perl
#Running this script calculates the percentage methylation and coverage at each cytosine for all the genome-wide cytosine files produced by Bismark in the directory.

$dir=shift || '.';

opendir(DIR, $dir) || die $!;

for $file(readdir(DIR)) {
	next unless $file =~ /(\S+)\.txt$/;
	open (INPUT,"$file");
	$outfile=$file."out.txt";
	open (OUTPUT,">$outfile");
	$text=<INPUT>;
	chomp($text);
	print OUTPUT $text."\tper_methylation\tcoverage\n";
	while ($text=<INPUT>){
		chomp($text);
		@list=split(/\t/,$text);
		($chromosome, $position, $strand, $count_methylated, $count_unmethylated, $C_context, $trinucleotide_context)=@list;
		$cov=$count_methylated+$count_unmethylated;
		if ($cov > 0){
			$per_methylation = ($count_methylated/$cov)*100;
		}
		else{
			$per_methylation = -1;
		}
		print OUTPUT "$text\t$per_methylation\t$cov\n";
	}
	close(INPUT);
	close(OUTPUT);
}