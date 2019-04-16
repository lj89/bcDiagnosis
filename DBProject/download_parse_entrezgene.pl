#! /usr/bin/env perl
use warnings;

################################################################ 
#
# Author:      Bioinformatics and Research Computing, Whitehead Institute
#              wibr-bioinformatics@wi.mit.edu
#
# Purpose:     Perl script to download and parse NCBI files for Entrez Gene database
#               
# Date:        Last updated October 2014 
#
#################################################################


######  Change information as appropriate 

# Where files will be downloaded and unzipped
$downloadDir = "download";

# Where formatted files (ready for database import) will be saved
$SQL = "sql_ready";

####### End of User variables


# Removed addition of single quotes around each field
#   and made a few other file-specific replacements to prevent MySQL loading warnings
# George Bell -- 17 Jan 2012
# George Bell -- 27 June 2014 -- Fixed some problems

# list of all tables

# Note: mim2gene removed on 27 June 2014 -- It needs to be downloaded from omim.org (and requires a username/password)
# We can add it back later but as of now we don't use it so let's skip it.

@tables = qw(
gene2accession
gene_history
gene_info
gene2go
gene2pubmed
gene2refseq
gene2sts
gene2unigene
generifs_basic
interactions
tax2name
refSeqSummary
);

#downloaded files - zipped
@zip_files = qw(
gene_history
gene2accession
gene_info
gene2go
gene2pubmed
gene2refseq
);

# downloaded files - unzipped
@download_files = qw(
gene2sts
gene2unigene
);

# downloaded files -- RIFs
@geneRIF = qw(
generifs_basic
interactions
);

# Make directories (if needed)

if (! -d $downloadDir)
{
	mkdir "$downloadDir", "0755" or die "Cannot create directory $downloadDir: $!";
	print STDERR "Created $downloadDir\n";
}
if (! -d $SQL)
{
	mkdir "$SQL", "0755" or die "Cannot create directory $SQL: $!";
	print STDERR "Created $SQL\n";
}

# remove previously downloaded files

foreach $old (@tables)
{
	if ($old ne 'refSeqSummary')
	{
		`rm -Rf "$downloadDir/$old" `;
		`rm -Rf "$downloadDir/*.dmp"  "$downloadDir/*.prt" "$downloadDir/*.txt" `;
	}
}

# using unix command wget - download new zip files
# rm *.zip file after unzipping
foreach $zip (@zip_files)
{
	my $ftp_site = "ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/" . $zip . ".gz";
	my $zip_input_file = "$downloadDir/$zip.gz";
	print STDERR "Downloading $zip to $downloadDir and gunzipping...\n";
	`wget -q $ftp_site -O $zip_input_file`;
	`gunzip $zip_input_file`;
	`rm -Rf $zip_input_file`;
}

# using unix command wget - download new files
foreach $down (@download_files)
{
	my $ftp_site = "ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/" . $down;
	my $zip_input_file = "$downloadDir/$down";
	print STDERR "Downloading $down to $zip_input_file...\n";
	`wget -q $ftp_site -O $zip_input_file`;
}

# using unix command wget - download new zip files
# rm *.zip file after unzipping

foreach $rif (@geneRIF)
{
	my $ftp_site = "ftp://ftp.ncbi.nlm.nih.gov/gene/GeneRIF/" . $rif . ".gz";
	my $zip_input_file = "$downloadDir/$rif.gz";
	print STDERR "Downloading $rif to $downloadDir and gunzipping...\n";
	`wget -q $ftp_site -O $zip_input_file`;
	`gunzip $zip_input_file`;
	`rm -Rf $zip_input_file`;
}

# using unix command wget - download new zip files
# rm *.zip file after unzipping

my $ftp_site = "ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz";
my $zip_input_file = "$downloadDir/taxdump.tar.gz";
print STDERR "Downloading taxdump to $downloadDir...\n";
`wget -q $ftp_site -O $zip_input_file`;
`tar -zxf $zip_input_file -C $downloadDir`;

#######
#
# INSERT INTO FILES
#
#######

# for each newly downloaded file;
# parse each file (ignoring comments), add a primary id, and print out
# information (tab-delimited) to a new file (named the same as $file)

$line = '';
$primary_id= 0;

foreach $file (@tables)
{
	chomp $file;
	if ($file eq ''){next;}
	if ($file eq "refSeqSummary"){next;}
	
	print STDERR "Inserting unique identifier (line number) into *$file*\n";
	
	if ($file eq "tax2name")
	{
		# Taxonomy is a little different from Entrez Gene
		# I need to parse out the information that I need from names.dmp

		$file = "$downloadDir/names.dmp";

		open (READ, $file) || print "Can't open $file for reading: $!\n";
		open (TAX, ">$SQL/tax2name") || print "Can't write to file $SQL/tax2name\n";

		while (<READ>)
		{
			chomp($_);


			@fields = split(/\t/,$_);

			if($fields[6] =~ /scientific/i)

			{
				$tax_id = $fields[0]; $tax_id =~ s/^s+//; $tax_id =~ s/\s+$//;
				$name = $fields[2]; $name =~ s/^s+//; $name =~ s/\s+$//;
	
				print TAX "$tax_id\t$name\n";
			}
		}
		next;
	}
	elsif ($file eq "gene2refseq")
	{
		open (READ, "$downloadDir/$file");
		open (SQL, ">$SQL/$file");
		$primary_id =0;
		while (<READ>)
		{
			chomp($_);
			if ($_ =~ /^#/)
			{
				next;
			}	
			$primary_id++;
			@data = split(/\t/,$_);
			# $line = "\'$primary_id\'\t";
			$line = "$primary_id\t";
			for ($i=0; $i< @data; $i++)
			{ 
				if ( ($i == 3) || ($i == 5)  || ($i == 7) )
				{
					$data[$i] =~ s/\..*//;
				}
				$data[$i] =~ s/^\s+//;
				$data[$i] =~ s/\s+$//;
				# $line .= "\'$data[$i]\'\t";
				$line .= "$data[$i]\t";
			}

			$line =~ s/\t$/\n/;
			print SQL "$line";

		}
	}
	else
	{
		open (READ, "$downloadDir/$file") || die "Cannot open $downloadDir/$file for reading: $!";
		open (SQL, ">$SQL/$file") || die "Cannot open $SQL/$file for writing: $!";
		$primary_id =0;
		while (<READ>)
		{
			chomp($_);
			if ($_ =~ /^#/)
			{
				next;
			}	
			$primary_id++;
			@data = split(/\t/,$_);
			
			# change fields to prevernt SQL warnings (GB -- 17 Jan13)
			if ($file eq "gene_history" && $data[1] eq "-")
			{
				$data[1]  = 0;
			}
			elsif ($file eq "interactions" && $data[5] eq "-")
			{
				$data[5]  = 0;
			}			
			# $line = "\'$primary_id\'\t";
			$line = "$primary_id\t";
						
			for ($i=0; $i< @data; $i++)
			{ 
				$data[$i] =~ s/^\s+//;
				$data[$i] =~ s/\s+$//;
				# $line .= "\'$data[$i]\'\t";
				$line .= "$data[$i]\t";
			}

			$line =~ s/\t$/\n/;
			print SQL "$line";
		}
	}
}