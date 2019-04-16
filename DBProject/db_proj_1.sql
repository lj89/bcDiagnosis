use mydb;

select count(*) as count from biopsy
#where Patient_ID=8670
limit 100;


#genotypePatient_ID


SELECT * FROM genotype
limit 100;



select 
date_format(oh.OrderDate ,'%m')  Mon,
sum(ol.PricePerQty*ol.Quantity)  MonthlyTotal ,
ol.Item_ItemNumber 					 ItemNumber
from
OrderHeader as oh , 
OrderLine as ol 
where 
Oh.OrderNumber = ol.OrderHeader_OrderNumber
group by
ItemNumber , Mon 
order by 
Mon , MonthlyTotal desc ;



CREATE DATABASE `entrez_gene` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `entrez_gene`;

CREATE TABLE `gene2accession` (
  `primary_id` bigint(20) NOT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `RNA_nuc_access_version` varchar(30) DEFAULT NULL,
  `RNA_nuc_gi` varchar(30) DEFAULT NULL,
  `protein_access_version` varchar(30) DEFAULT NULL,
  `protein_gi` varchar(30) DEFAULT NULL,
  `genome_nuc_access_version` varchar(30) DEFAULT NULL,
  `genome_nuc_gi` varchar(30) DEFAULT NULL,
  `start_pos_gen_access` varchar(30) DEFAULT NULL,
  `end_pos_gen_access` varchar(30) DEFAULT NULL,
  `orientation` varchar(30) DEFAULT NULL,
  `assembly` varchar(80) DEFAULT NULL,
  `mature_peptide_accession.version` varchar(30) DEFAULT NULL,
  `mature_peptide_gi` varchar(30) DEFAULT NULL,
  `Symbol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene2accession_index_tax` (`tax_id`),
  KEY `gene2accession_index_nuc` (`RNA_nuc_access_version`),
  KEY `gene2accession_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene2go` (
  `primary_id` bigint(20) NOT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `go_id` varchar(30) DEFAULT NULL,
  `evidence` varchar(250) DEFAULT NULL,
  `qualifier` varchar(250) DEFAULT NULL,
  `go_term` varchar(250) DEFAULT NULL,
  `pubmed_ids` varchar(250) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene2go_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene2pubmed` (
  `primary_id` bigint(20) NOT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `pubmed_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene2pubmed_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene2refseq` (
  `primary_id` bigint(20) NOT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `RNA_nuc_access_version` varchar(30) DEFAULT NULL,
  `RNA_nuc_gi` varchar(30) DEFAULT NULL,
  `protein_access_version` varchar(30) DEFAULT NULL,
  `protein_gi` varchar(30) DEFAULT NULL,
  `genome_nuc_access_version` varchar(30) DEFAULT NULL,
  `genome_nuc_gi` varchar(30) DEFAULT NULL,
  `start_pos_gen_access` varchar(30) DEFAULT NULL,
  `end_pos_gen_access` varchar(30) DEFAULT NULL,
  `orientation` varchar(30) DEFAULT NULL,
  `assembly` varchar(80) DEFAULT NULL,
  `mature_peptide_accession.version` varchar(30) DEFAULT NULL,
  `mature_peptide_gi` varchar(30) DEFAULT NULL,
  `Symbol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene2refseq_index_protein` (`protein_access_version`),
  KEY `gene2refseq_index_nuc` (`RNA_nuc_access_version`),
  KEY `gene2refseq_index_tax` (`tax_id`),
  KEY `gene2refseq_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene2sts` (
  `primary_id` bigint(20) NOT NULL DEFAULT '0',
  `gene_id` int(11) DEFAULT NULL,
  `UniSTS_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene2sts_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene2unigene` (
  `primary_id` bigint(20) NOT NULL DEFAULT '0',
  `gene_id` int(11) DEFAULT NULL,
  `unigene_cluster` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene2unigene_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene_history` (
  `primary_id` bigint(20) NOT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `disc_gene_id` int(11) DEFAULT NULL,
  `disc_symbol` varchar(34) DEFAULT NULL,
  `disc_date` date DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene_history_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `gene_info` (
  `primary_id` bigint(20) NOT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `locusTag` varchar(30) DEFAULT NULL,
  `synonyms` text,
  `dbXrefs` text,
  `chromosome` text,
  `map_location` text,
  `description` text,
  `type_of_gene` varchar(30) DEFAULT NULL,
  `symbol_nomen` varchar(30) DEFAULT NULL,
  `full_name_nomen` text,
  `status_nomen` varchar(30) DEFAULT NULL,
  `other_designations` text,
  `mod_date` date DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `gene_info_indextax` (`tax_id`),
  KEY `gene_info_indexsym` (`symbol_nomen`),
  KEY `gene_info_index_symbol` (`symbol`),
  KEY `gene_info_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `generifs_basic` (
  `primary_id` bigint(20) NOT NULL DEFAULT '0',
  `tax_id` int(11) DEFAULT NULL,
  `gene_id` int(11) DEFAULT NULL,
  `pubmed_id` varchar(250) DEFAULT NULL,
  `last_update` varchar(30) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`primary_id`),
  KEY `generifs_basic_index` (`gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `interactions` (
  `primary_id` bigint(20) NOT NULL,
  `1_tax_id` int(11) DEFAULT NULL,
  `1_gene_id` int(11) DEFAULT NULL,
  `1_accn_vers` varchar(30) DEFAULT NULL,
  `1_name` text,
  `keyphrase` varchar(250) DEFAULT NULL,
  `2_tax_id` int(11) DEFAULT NULL,
  `2_interactant_id` varchar(30) DEFAULT NULL,
  `2_interactant_id_type` varchar(30) DEFAULT NULL,
  `2_accn_vers` varchar(30) DEFAULT NULL,
  `2_name` text,
  `complex_id` varchar(50) DEFAULT NULL,
  `complex_id_type` varchar(30) DEFAULT NULL,
  `complex_name` varchar(250) DEFAULT NULL,
  `pubmed_id_list` text,
  `last_mod` varchar(30) DEFAULT NULL,
  `generif_text` text,
  `source_interactant_id` varchar(30) DEFAULT NULL,
  `source_interactant_id_type` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `interactions_index` (`1_gene_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `refSeqSummary` (
  `primary_id` bigint(20) NOT NULL DEFAULT '0',
  `gene_id` int(11) DEFAULT NULL,
  `mrnaAcc` varchar(255) NOT NULL DEFAULT '',
  `completeness` enum('Unknown','Complete5End','Complete3End','FullLength','IncompleteBothEnds','Incomplete5End','Incomplete3End','Partial') NOT NULL DEFAULT 'Unknown',
  `summary` text NOT NULL,
  PRIMARY KEY (`primary_id`),
  KEY `refSeqSummary_indexgene` (`gene_id`),
  KEY `refSeqSummary_index` (`mrnaAcc`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `tax2name` (
  `tax_id` int(11) DEFAULT NULL,
  `organism` text,
  KEY `tax2name_index` (`tax_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



USE `entrez_gene`;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\gene_history'
INTO TABLE gene_history; 
SELECT COUNT(*) AS COUNT FROM gene_history;

