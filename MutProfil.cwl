{
  "class": "Workflow",
  "cwlVersion": "v1.2",
  "label": "SBG FASTA Indices+Haplotype Caller",
  "$namespaces": {
    "sbg": "https://sevenbridges.com"
  },
  "inputs": [
    {
      "id": "reference",
      "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ",
      "type": "File",
      "label": "Reference genome",
      "doc": "FASTA file to be indexed",
      "sbg:x": -478.3999938964844,
      "sbg:y": -40.650001525878906
    },
    {
      "id": "input_reads",
      "sbg:fileTypes": "FASTQ, FASTQ.GZ, FQ, FQ.GZ",
      "type": "File[]",
      "label": "Input reads",
      "doc": "Input sequence reads.",
      "sbg:x": -480.75,
      "sbg:y": 178
    },
    {
      "id": "deduplication",
      "type": [
        "null",
        {
          "type": "enum",
          "symbols": [
            "None",
            "MarkDuplicates",
            "RemoveDuplicates"
          ],
          "name": "deduplication"
        }
      ],
      "label": "PCR duplicate detection",
      "doc": "Use Biobambam2 for finding duplicates on sequence reads.",
      "sbg:exposed": true
    },
    {
      "id": "cache_file",
      "sbg:fileTypes": "TAR.GZ",
      "type": "File",
      "label": "Species cache file",
      "doc": "Cache file for the chosen species.",
      "sbg:x": -478.75,
      "sbg:y": -191.66172790527344
    },
    {
      "id": "species",
      "type": "string?",
      "label": "Species",
      "doc": "Species.",
      "sbg:exposed": true
    },
    {
      "id": "variant_class",
      "type": "boolean?",
      "label": "Output Sequence Ontology variant class",
      "doc": "Output the Sequence Ontology variant class. Not used by default.",
      "sbg:exposed": true
    },
    {
      "id": "pick",
      "type": "boolean?",
      "label": "Pick one line or block of consequence data per variant, including transcript-specific columns",
      "doc": "Pick one line or block of consequence data per variant, including transcript-specific columns. Consequences are chosen according to the criteria described here, and the order the criteria are applied may be customised with --pick_order. This is the best method to use if you are interested only in one consequence per variant. Not used by default.",
      "sbg:exposed": true
    }
  ],
  "outputs": [
    {
      "id": "vep_output_file",
      "outputSource": [
        "variant_effect_predictor_101_0_cwl1_0/vep_output_file"
      ],
      "sbg:fileTypes": "VCF, TXT, JSON, TAB",
      "type": "File?",
      "label": "VEP output file",
      "doc": "Output file (annotated VCF) from VEP.",
      "sbg:x": 639.6500244140625,
      "sbg:y": -47.349998474121094
    },
    {
      "id": "summary_file",
      "outputSource": [
        "variant_effect_predictor_101_0_cwl1_0/summary_file"
      ],
      "sbg:fileTypes": "HTML, TXT",
      "type": "File?",
      "label": "Output summary stats file",
      "doc": "Summary stats file, if requested.",
      "sbg:x": 639.3499755859375,
      "sbg:y": 128.15000915527344
    },
    {
      "id": "output_file",
      "outputSource": [
        "bcftools_consensus/output_file"
      ],
      "sbg:fileTypes": "VCF, BCF, VCF.GZ, BCF.GZ",
      "type": "File?",
      "label": "Output file",
      "doc": "Consensus sequence",
      "sbg:x": 641.7999877929688,
      "sbg:y": -178.39999389648438
    }
  ],
  "steps": [
    {
      "id": "sbg_fasta_indices",
      "in": [
        {
          "id": "reference",
          "source": "reference"
        }
      ],
      "out": [
        {
          "id": "fasta_reference"
        },
        {
          "id": "fasta_index"
        },
        {
          "id": "fasta_dict"
        }
      ],
      "run": {
        "cwlVersion": "sbg:draft-2",
        "class": "CommandLineTool",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "id": "admin/sbg-public-data/sbg-fasta-indices/20",
        "label": "SBG FASTA Indices",
        "description": "Create indices for FASTA file.\n\n###**Overview**  \n\nTool allows creating FASTA dictionary and index simultaneously which is necessary for running GATK tools. This version of tool for indexing uses SAMtools faidx command (toolkit version 1.9), while for the FASTA dictionary is used CreateFastaDictionary (GATK toolkit version 4.1.0.0).\n\n\n###**Inputs**  \n\n- FASTA file \n\n###**Output**  \n\n- FASTA Reference file\n- FASTA Index file\n- FASTA Dictionary file\n\n\n###**Changes made by Seven Bridges**\n\nCreateFastaDictionary function creates a DICT file describing the contents of the FASTA file. Parameter -UR was added to the command line that sets the UR field to just the Reference file name, instead of the whole path to file. This allows Memoisation feature of the platform to work.",
        "baseCommand": [
          "samtools",
          "faidx"
        ],
        "inputs": [
          {
            "sbg:stageInput": "link",
            "sbg:category": "Input files",
            "type": [
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "FASTA file",
            "description": "FASTA file to be indexed",
            "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ",
            "id": "#reference"
          },
          {
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "2048",
            "type": [
              "null",
              "int"
            ],
            "label": "Memory per job",
            "description": "Memory in megabytes required for each execution of the tool.",
            "id": "#memory_per_job"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "label": "Reference",
            "sbg:fileTypes": "FASTA",
            "outputBinding": {
              "glob": {
                "script": "{\n  return $job.inputs.reference.path.split('/').pop()\n}",
                "class": "Expression",
                "engine": "#cwl-js-engine"
              },
              "sbg:inheritMetadataFrom": "#reference",
              "secondaryFiles": [
                ".fai",
                "^.dict",
                "^^.dict"
              ]
            },
            "id": "#fasta_reference"
          },
          {
            "type": [
              "null",
              "File"
            ],
            "label": "FASTA Index",
            "sbg:fileTypes": "FAI",
            "outputBinding": {
              "glob": "*.fai"
            },
            "id": "#fasta_index"
          },
          {
            "type": [
              "null",
              "File"
            ],
            "label": "FASTA Dictionary",
            "sbg:fileTypes": "DICT",
            "outputBinding": {
              "glob": "*.dict"
            },
            "id": "#fasta_dict"
          }
        ],
        "requirements": [
          {
            "class": "ExpressionEngineRequirement",
            "id": "#cwl-js-engine",
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ]
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": 1
          },
          {
            "class": "sbg:MemRequirement",
            "value": {
              "script": "{\n  if($job.inputs.memory_per_job)return $job.inputs.memory_per_job + 500\n  else return 2548\n}",
              "class": "Expression",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "class": "DockerRequirement",
            "dockerImageId": "b177f5bd06db",
            "dockerPull": "images.sbgenomics.com/vladimirk/gatk4-samtools:4.1.4.0-1.9"
          }
        ],
        "arguments": [
          {
            "position": 1,
            "prefix": "&&",
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "engine": "#cwl-js-engine",
              "script": "{\n  memory = '2048'\n  if ($job.inputs.memory_per_job){\n    memory = $job.inputs.memory_per_job\n  }\n  filename = $job.inputs.reference.path.split('/').pop()\n  basename = filename.split('.')\n  if (filename.endsWith('.gz')){\n    basename.pop()\n  }\n  basename.pop()\n  name = basename.join('.')\n  return 'java -Xmx' + memory + 'M -jar /gatk/gatk-package-4.1.0.0-local.jar CreateSequenceDictionary -R=' + $job.inputs.reference.path + ' -O=' + name + '.dict'\n}"
            }
          },
          {
            "position": 3,
            "prefix": "-UR=",
            "separate": false,
            "valueFrom": {
              "class": "Expression",
              "engine": "#cwl-js-engine",
              "script": "{\n  return $job.inputs.reference.path.split('/')[ $job.inputs.reference.path.split('/').length - 1]\n}"
            }
          }
        ],
        "sbg:toolAuthor": "Sanja Mijalkovic, Seven Bridges Genomics, <sanja.mijalkovic@sbgenomics.com>",
        "sbg:cmdPreview": "samtools faidx  /path/to/reference.fa.gz && java -Xmx10M -jar /gatk/gatk-package-4.1.0.0-local.jar CreateSequenceDictionary -R=/path/to/reference.fa.gz -O=reference.dict -UR=reference.fa.gz",
        "sbg:toolkit": "SBGTools",
        "sbg:image_url": null,
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 510
          },
          "inputs": {
            "reference": {
              "secondaryFiles": [],
              "path": "/path/to/reference.fa.gz",
              "size": 0,
              "class": "File"
            },
            "memory_per_job": 10
          }
        },
        "sbg:projectName": "SBG Public data",
        "sbg:categories": [
          "Indexing"
        ],
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "sanja.mijalkovic",
            "sbg:modifiedOn": 1448043983,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "djordje_klisic",
            "sbg:modifiedOn": 1459163478,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "djordje_klisic",
            "sbg:modifiedOn": 1459163478,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "djordje_klisic",
            "sbg:modifiedOn": 1459163478,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "djordje_klisic",
            "sbg:modifiedOn": 1459163478,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1504629640,
            "sbg:revisionNotes": "Removed python script. Changed docker to just samtools and picard. Wrapped both faidx and CreateSequenceDictionary and exposed memory parameter for java execution."
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1506681176,
            "sbg:revisionNotes": "Changed join to join('.')."
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1521479429,
            "sbg:revisionNotes": "Added support for FA.GZ, FASTA.GZ"
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1521479429,
            "sbg:revisionNotes": "Added secondary .dict support for fasta.gz"
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1530631714,
            "sbg:revisionNotes": "returned to rev 8"
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1530631714,
            "sbg:revisionNotes": "rev 7"
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1530631714,
            "sbg:revisionNotes": "rev 9: Added secondary .dict support"
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1545924498,
            "sbg:revisionNotes": "Updated version for samtools (1.9) and picard (2.18.14)"
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1545924498,
            "sbg:revisionNotes": "Reverted."
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1575892952,
            "sbg:revisionNotes": "Added URI to eliminate randomness in .dict"
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1575892952,
            "sbg:revisionNotes": "Added URI to remove randomness"
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1575892952,
            "sbg:revisionNotes": "Updated to GATK 4.1.0.0"
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1575892952,
            "sbg:revisionNotes": "bug fix"
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1575892952,
            "sbg:revisionNotes": "description"
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1575892952,
            "sbg:revisionNotes": "updated command line preview"
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1630934170,
            "sbg:revisionNotes": "Tool description update to clarify it only takes one FASTA file"
          }
        ],
        "sbg:license": "Apache License 2.0",
        "sbg:expand_workflow": false,
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:id": "admin/sbg-public-data/sbg-fasta-indices/20",
        "sbg:revision": 20,
        "sbg:revisionNotes": "Tool description update to clarify it only takes one FASTA file",
        "sbg:modifiedOn": 1630934170,
        "sbg:modifiedBy": "admin",
        "sbg:createdOn": 1448043983,
        "sbg:createdBy": "sanja.mijalkovic",
        "sbg:project": "admin/sbg-public-data",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "sanja.mijalkovic",
          "admin",
          "djordje_klisic"
        ],
        "sbg:latestRevision": 20,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a21b3ebe8e82b8fd5100676f5de37ea9b35992d0cbbb0c97a62c7e6a8dea4d620"
      },
      "label": "SBG FASTA Indices",
      "sbg:x": -190.35000610351562,
      "sbg:y": -40.650001525878906
    },
    {
      "id": "gatk_4_0_haplotypecaller",
      "in": [
        {
          "id": "reads",
          "source": [
            "bwa_mem_bundle_0_7_17/aligned_reads"
          ]
        },
        {
          "id": "reference",
          "source": "sbg_fasta_indices/fasta_reference"
        }
      ],
      "out": [
        {
          "id": "output_vcf"
        },
        {
          "id": "output_bam"
        }
      ],
      "run": {
        "cwlVersion": "sbg:draft-2",
        "class": "CommandLineTool",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "id": "admin/sbg-public-data/gatk-4-0-haplotypecaller/33",
        "label": "GATK HaplotypeCaller",
        "description": "Call germline SNPs and indels via local re-assembly of haplotypes.\n\n###**Overview**  \n\nThe HaplotypeCaller is capable of calling SNPs and indels simultaneously via local de-novo assembly of haplotypes in an active region. In other words, whenever the program encounters a region showing signs of variation, it discards the existing mapping information and completely reassembles the reads in that region. This allows the HaplotypeCaller to be more accurate when calling regions that are traditionally difficult to call, for example when they contain different types of variants close to each other. It also makes the HaplotypeCaller much better at calling indels than position-based callers like UnifiedGenotyper.\n\nIn the GVCF workflow used for scalable variant calling in DNA sequence data, HaplotypeCaller runs per-sample to generate an intermediate GVCF (not to be used in final analysis), which can then be used in GenotypeGVCFs for joint genotyping of multiple samples in a very efficient way. The GVCF workflow enables rapid incremental processing of samples as they roll off the sequencer, as well as scaling to very large cohort sizes (e.g. the 92K exomes of ExAC).\n\nIn addition, HaplotypeCaller is able to handle non-diploid organisms as well as pooled experiment data. Note however that the algorithms used to calculate variant likelihoods is not well suited to extreme allele frequencies (relative to ploidy) so its use is not recommended for somatic (cancer) variant discovery. For that purpose, use Mutect2 instead.\n\nFinally, HaplotypeCaller is also able to correctly handle the splice junctions that make RNAseq a challenge for most variant callers, on the condition that the input read data has previously been processed according to our recommendations as documented here. \n\n###**Input**  \nInput bam file(s) from which to make variant calls\n\n###**Output**  \nEither a VCF or GVCF file with raw, unfiltered SNP and indel calls. Regular VCFs must be filtered either by variant recalibration (Best Practice) or hard-filtering before use in downstream analyses. If using the GVCF workflow, the output is a GVCF file that must first be run through GenotypeGVCFs and then filtering before further analysis.\n\n###**Usage examples**  \nThese are example commands that show how to run HaplotypeCaller for typical use cases. Have a look at the method documentation for the basic GVCF workflow.\n\n####**Single-sample GVCF calling (outputs intermediate GVCF)**\n\n     gatk-launch --javaOptions \"-Xmx4g\" HaplotypeCaller  \\\n       -R reference.fasta \\\n       -I input.bam \\\n       -O output.g.vcf \\\n       -ERC GVCF\n\n####**Single-sample GVCF calling with allele-specific annotations**\n\n     gatk-launch --javaOptions \"-Xmx4g\" HaplotypeCaller  \\\n       -R reference.fasta \\\n       -I input.bam \\\n       -O output.g.vcf \\\n       -ERC GVCF \\\n       -G Standard \\\n       -G AS_Standard\n\n####**Variant calling with bamout to show realigned reads**\n\n     gatk-launch --javaOptions \"-Xmx4g\" HaplotypeCaller  \\\n       -R reference.fasta \\\n       -I input.bam \\\n       -O output.vcf \\\n       -bamout bamout.bam\n\n###**Caveats**\n\n- We have not yet fully tested the interaction between the GVCF-based calling or the multisample calling and the RNAseq-specific functionalities. Use those in combination at your own risk.\n\n###**Special note on ploidy**\n\nThis tool is able to handle many non-diploid use cases; the desired ploidy can be specified using the -ploidy argument. Note however that very high ploidies (such as are encountered in large pooled experiments) may cause performance challenges including excessive slowness. We are working on resolving these limitations.\n\n###**Additional Notes**\n- When working with PCR-free data, be sure to set `-pcr_indel_model NONE` (see argument below).\n- When running in `-ERC GVCF` or `-ERC BP_RESOLUTION` modes, the confidence threshold is automatically set to 0. This cannot be overridden by the command line. The threshold can be set manually to the desired level in the next step of the workflow (GenotypeGVCFs)\n- We recommend using a list of intervals to speed up analysis. See this document for details.\n- When using genotype given alleles mode, GATK HaplotypeCaller will try to confirm mutations in a given BAM file. If there are no reads for a position given in the alleles file, the output VCF will not contain that position.\n- By default, the tool works only with VCF resource files. To use VCF.GZ resource files, the tool wrapper needs to be modified.\n\n###**IMPORTANT NOTICE**  \n\nTools in GATK that require a fasta reference file also look for the reference file's corresponding *.fai* (fasta index) and *.dict* (fasta dictionary) files. The fasta index file allows random access to reference bases and the dictionary file is a dictionary of the contig names and sizes contained within the fasta reference. These two secondary files are essential for GATK to work properly. To append these two files to your fasta reference please use the '***SBG FASTA Indices***' tool within your GATK based workflow before using any of the GATK tools.",
        "baseCommand": [
          "/gatk/gatk",
          "--java-options",
          {
            "class": "Expression",
            "script": "{\n  memory = 0\n  \n  if($job.inputs.memory_per_job){\n  \t memory = $job.inputs.memory_per_job\n  }\n  else{\n    if($job.inputs.wgs_hg38_mode_memory){\n      \treference_name = $job.inputs.reference.path.replace(/^.*[\\\\\\/]/, '')\n      \n       \tif(reference_name.indexOf('38') >-1){\n      \t\tmemory = $job.inputs.wgs_hg38_mode_memory\n    \t}\n        else{\n       \t\tmemory = 2048 \n        }\n    }\n  \telse{\n       memory = 2048\n  \t}\n  }\n  \n  return '\\\"-Xmx'.concat(memory, 'M') + '\\\"'\n}",
            "engine": "#cwl-js-engine"
          },
          "HaplotypeCaller"
        ],
        "inputs": [
          {
            "sbg:altPrefix": "",
            "sbg:category": "Required Arguments",
            "type": [
              {
                "type": "array",
                "items": "File"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--input",
              "separate": true,
              "sbg:cmdInclude": true,
              "secondaryFiles": [
                ".bai"
              ]
            },
            "label": "Reads",
            "description": "BAM/SAM/CRAM file containing reads This argument must be specified at least once. Required.",
            "sbg:fileTypes": "BAM",
            "id": "#reads"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Required Arguments",
            "type": [
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--reference",
              "separate": true,
              "sbg:cmdInclude": true,
              "secondaryFiles": [
                ".fai",
                "^.dict"
              ]
            },
            "label": "Reference",
            "description": "Reference sequence file Required.",
            "id": "#reference"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--add-output-sam-program-record",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Add Output Sam Program Record",
            "description": "If true, adds a PG tag to created SAM/BAM/CRAM files. Default value: true. Possible values: {true, false}.",
            "id": "#add_output_sam_program_record"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--alleles",
              "separate": true,
              "sbg:cmdInclude": true,
              "secondaryFiles": [
                ".idx"
              ]
            },
            "label": "Alleles",
            "description": "The set of alleles at which to genotype when --genotyping_mode is GENOTYPE_GIVEN_ALLELES Default value: null.",
            "id": "#alleles"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--annotate-with-num-discovered-alleles",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Annotate Nda",
            "description": "If provided, we will annotate records with the number of alternate alleles that were discovered (but not necessarily genotyped) at a given site Default value: false. Possible values: {true, false}.",
            "id": "#annotate_nda"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--assembly-region-padding",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Assembly Region Padding",
            "description": "Number of additional bases of context to include around each assembly region Default value: 100.",
            "id": "#assembly_region_padding"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--base-quality-score-threshold",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Base Quality Score Threshold",
            "description": "Base qualities below this threshold will be reduced to the minimum (6) Default value: 18.",
            "id": "#base_quality_score_threshold"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--cloud-index-prefetch-buffer",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Cloud Index Prefetch Buffer",
            "description": "Size of the cloud-only prefetch buffer (in MB; 0 to disable). Defaults to cloudPrefetchBuffer if unset. Default value: -1.",
            "id": "#cloud_index_prefetch_buffer"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--cloud-prefetch-buffer",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Cloud Prefetch Buffer",
            "description": "Size of the cloud-only prefetch buffer (in MB; 0 to disable). Default value: 40.",
            "id": "#cloud_prefetch_buffer"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--contamination-fraction-to-filter",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Contamination Fraction To Filter",
            "description": "Fraction of contamination in sequencing data (for all samples) to aggressively remove Default value: 0.0.",
            "id": "#contamination_fraction_to_filter"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--create-output-bam-index",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Create Output Bam Index",
            "description": "If true, create a BAM/CRAM index when writing a coordinate-sorted BAM/CRAM file. Default value: true. Possible values: {true, false}.",
            "id": "#create_output_bam_index"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--create-output-bam-md5",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Create Output Bam Md5",
            "description": "If true, create a MD5 digest for any BAM/SAM/CRAM file created Default value: false. Possible values: {true, false}.",
            "id": "#create_output_bam_md5"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--create-output-variant-index",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Create Output Variant Index",
            "description": "If true, create a VCF index when writing a coordinate-sorted VCF file. Default value: true. Possible values: {true, false}.",
            "id": "#create_output_variant_index"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--create-output-variant-md5",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Create Output Variant Md5",
            "description": "If true, create a a MD5 digest any VCF file created. Default value: false. Possible values: {true, false}.",
            "id": "#create_output_variant_md5"
          },
          {
            "sbg:altPrefix": "-D",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "separate": true,
              "valueFrom": {
                "class": "Expression",
                "script": "{\n  if($job.inputs.db_snp)\n    return '--dbsnp ' + [].concat($job.inputs.db_snp)[0].path\n  else return ''\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:cmdInclude": true,
              "secondaryFiles": [
                ".idx"
              ]
            },
            "label": "Db Snp",
            "description": "DbSNP file Default value: null.",
            "sbg:fileTypes": "VCF",
            "id": "#db_snp"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--disable-bam-index-caching",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Disable Bam Index Caching",
            "description": "If true, don't cache bam indexes, this will reduce memory requirements but may harm performance if many intervals are specified. Caching is automatically disabled if there are no intervals specified. Default value: false. Possible values: {true, false}.",
            "id": "#disable_bam_index_caching"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "GoodCigarReadFilter",
                  "MappedReadFilter",
                  "MappingQualityAvailableReadFilter",
                  "MappingQualityReadFilter",
                  "NonZeroReferenceLengthAlignmentReadFilter",
                  "NotDuplicateReadFilter",
                  "NotSecondaryAlignmentReadFilter",
                  "PassesVendorQualityCheckReadFilter",
                  "WellformedReadFilter"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--disable-read-filter",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Disable Read Filter",
            "description": "Read filters to be disabled before analysis This argument may be specified 0 or more times. Default value: null.",
            "id": "#disable_read_filter"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--disable-sequence-dictionary-validation",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Disable Sequence Dictionary Validation",
            "description": "If specified, do not check the sequence dictionaries from our inputs for compatibility. Use at your own risk! Default value: false. Possible values: {true, false}.",
            "id": "#disable_sequence_dictionary_validation"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--disable-tool-default-read-filters",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Disable Tool Default Read Filters",
            "description": "Disable all tool default read filters Default value: false. Possible values: {true, false}.",
            "id": "#disable_tool_default_read_filters"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "DISCOVERY",
                  "GENOTYPE_GIVEN_ALLELES"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--genotyping-mode",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Genotyping Mode",
            "description": "Specifies how to determine the alternate alleles to use for genotyping Default value: DISCOVERY. Possible values: {DISCOVERY, GENOTYPE_GIVEN_ALLELES}.",
            "id": "#genotyping_mode"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--graph-output",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Graph Output",
            "description": "Write debug assembly graph information to this file Default value: null.",
            "id": "#graph_output"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--heterozygosity",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Heterozygosity",
            "description": "Heterozygosity value used to compute prior likelihoods for any locus. See the GATKDocs for full details on the meaning of this population genetics concept Default value: 0.001.",
            "id": "#heterozygosity"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--heterozygosity-stdev",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Heterozygosity Stdev",
            "description": "Standard deviation of eterozygosity for SNP and indel calling. Default value: 0.01.",
            "id": "#heterozygosity_stdev"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--indel-heterozygosity",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Indel Heterozygosity",
            "description": "Heterozygosity for indel calling. See the GATKDocs for heterozygosity for full details on the meaning of this population genetics concept Default value: 1.25E-4.",
            "id": "#indel_heterozygosity"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--interval-exclusion-padding",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Interval Exclusion Padding",
            "description": "Amount of padding (in bp) to add to each interval you are excluding. Default value: 0.",
            "id": "#interval_exclusion_padding"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--interval-padding",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Interval Padding",
            "description": "Amount of padding (in bp) to add to each interval you are including. Default value: 0.",
            "id": "#interval_padding"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "UNION",
                  "INTERSECTION"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--interval-set-rule",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Interval Set Rule",
            "description": "Set merging approach to use for combining interval inputs Default value: UNION. Possible values: {UNION, INTERSECTION}.",
            "id": "#interval_set_rule"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--lenient",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Lenient",
            "description": "Lenient processing of VCF files Default value: false. Possible values: {true, false}.",
            "id": "#lenient"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-assembly-region-size",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Assembly Region Size",
            "description": "Maximum size of an assembly region Default value: 300.",
            "id": "#max_assembly_region_size"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-reads-per-alignment-start",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Reads Per Alignment Start",
            "description": "Maximum number of reads to retain per alignment start position. Reads above this threshold will be downsampled. Set to 0 to disable. Default value: 50.",
            "id": "#max_reads_per_alignment_start"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--min-base-quality-score",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Min Base Quality Score",
            "description": "Minimum base quality required to consider a base for calling Default value: 10.",
            "id": "#min_base_quality_score"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--min-assembly-region-size",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Min Assembly Region Size",
            "description": "Minimum size of an assembly region Default value: 50.",
            "id": "#min_assembly_region_size"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--native-pair-hmm-threads",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Native Pair Hmm Threads",
            "description": "How many threads should a native pairHMM implementation use Default value: 1.",
            "id": "#native_pair_hmm_threads"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "EMIT_VARIANTS_ONLY",
                  "EMIT_ALL_CONFIDENT_SITES",
                  "EMIT_ALL_SITES"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--output-mode",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Output Mode",
            "description": "Specifies which type of calls we should output Default value: EMIT_VARIANTS_ONLY. Possible values: {EMIT_VARIANTS_ONLY, EMIT_ALL_CONFIDENT_SITES, EMIT_ALL_SITES}.",
            "id": "#output_mode"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--quiet",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Quiet",
            "description": "Whether to suppress job-summary info on System.err. Default value: false. Possible values: {true, false}.",
            "id": "#quiet"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "AlignmentAgreesWithHeaderReadFilter",
                  "AllowAllReadsReadFilter",
                  "AmbiguousBaseReadFilter",
                  "CigarContainsNoNOperator",
                  "FirstOfPairReadFilter",
                  "FragmentLengthReadFilter",
                  "GoodCigarReadFilter",
                  "HasReadGroupReadFilter",
                  "LibraryReadFilter",
                  "MappedReadFilter",
                  "MappingQualityAvailableReadFilter",
                  "MappingQualityNotZeroReadFilter",
                  "MappingQualityReadFilter",
                  "MatchingBasesAndQualsReadFilter",
                  "MateDifferentStrandReadFilter",
                  "MateOnSameContigOrNoMappedMateReadFilter",
                  "MetricsReadFilter",
                  "NonZeroFragmentLengthReadFilter",
                  "NonZeroReferenceLengthAlignmentReadFilter",
                  "NotDuplicateReadFilter",
                  "NotOpticalDuplicateReadFilter",
                  "NotSecondaryAlignmentReadFilter",
                  "NotSupplementaryAlignmentReadFilter",
                  "OverclippedReadFilter",
                  "PairedReadFilter",
                  "PassesVendorQualityCheckReadFilter",
                  "PlatformReadFilter",
                  "PlatformUnitReadFilter",
                  "PrimaryLineReadFilter",
                  "ProperlyPairedReadFilter",
                  "ReadGroupBlackListReadFilter",
                  "ReadGroupReadFilter",
                  "ReadLengthEqualsCigarLengthReadFilter",
                  "ReadLengthReadFilter",
                  "ReadNameReadFilter",
                  "ReadStrandFilter",
                  "SampleReadFilter",
                  "SecondOfPairReadFilter",
                  "SeqIsStoredReadFilter",
                  "ValidAlignmentEndReadFilter",
                  "ValidAlignmentStartReadFilter",
                  "WellformedReadFilter"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--read-filter",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Read Filter",
            "description": "Read filters to be applied before analysis This argument may be specified 0 or more times. Default value: null.",
            "id": "#read_filter"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--read-index",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Read Index",
            "description": "Indices to use for the read inputs. If specified, an index must be provided for every read input and in the same order as the read inputs. If this argument is not specified, the path to the index for each input will be inferred automatically. This argument may be specified 0 or more times. Default value: null.",
            "id": "#read_index"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "STRICT",
                  "LENIENT",
                  "SILENT"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--read-validation-stringency",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Read Validation Stringency",
            "description": "Validation stringency for all SAM/BAM/CRAM/SRA files read by this program. The default stringency value SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded. Default value: SILENT. Possible values: {STRICT, LENIENT, SILENT}.",
            "id": "#read_validation_stringency"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--recover-dangling-heads",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Recover Dangling Heads",
            "description": "This argument is deprecated since version 3.3 Default value: false. Possible values: {true, false}.",
            "id": "#recover_dangling_heads"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--sample-name",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Sample Name",
            "description": "Name of single sample to use from a multi-sample bam Default value: null.",
            "id": "#sample_name"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--sample-ploidy",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Sample Ploidy",
            "description": "Ploidy (number of chromosomes) per sample. For pooled data, set to (Number of samples in each pool * Sample Ploidy). Default value: 2.",
            "id": "#sample_ploidy"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--seconds-between-progress-updates",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Seconds Between Progress Updates",
            "description": "Output traversal statistics every time this many seconds elapse Default value: 10.0.",
            "id": "#seconds_between_progress_updates"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--standard-min-confidence-threshold-for-calling",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Standard Min Confidence Threshold For Calling",
            "description": "The minimum phred-scaled confidence threshold at which variants should be called Default value: 10.0.",
            "id": "#standard_min_confidence_threshold_for_calling"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--use-jdk-deflater",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Use Jdk Deflater",
            "description": "Whether to use the JdkDeflater (as opposed to IntelDeflater) Default value: false. Possible values: {true, false}.",
            "id": "#use_jdk_deflater"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--use-jdk-inflater",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Use Jdk Inflater",
            "description": "Whether to use the JdkInflater (as opposed to IntelInflater) Default value: false. Possible values: {true, false}.",
            "id": "#use_jdk_inflater"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--use-new-qual-calculator",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Use New Qual Calculator",
            "description": "If provided, we will use the new qual model. Default value: false. Possible values: {true, false}.",
            "id": "#use_new_qual_calculator"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "ERROR",
                  "WARNING",
                  "INFO",
                  "DEBUG"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--verbosity",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Verbosity",
            "description": "Control verbosity of logging. Default value: INFO. Possible values: {ERROR, WARNING, INFO, DEBUG}.",
            "id": "#verbosity"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--active-probability-threshold",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Active Probability Threshold",
            "description": "Minimum probability for a locus to be considered active. Default value: 0.002.",
            "id": "#active_probability_threshold"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--allow-non-unique-kmers-in-ref",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Allow Non Unique Kmers In Ref",
            "description": "Allow graphs that have non-unique kmers in the reference Default value: false. Possible values: {true, false}.",
            "id": "#allow_non_unique_kmers_in_ref"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--all-site-p-ls",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "All Site P Ls",
            "description": "Annotate all sites with PLs Default value: false. Possible values: {true, false}.",
            "id": "#all_site_p_ls"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--annotation",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Annotation",
            "description": "One or more specific annotations to apply to variant calls This argument may be specified 0 or more times. Default value: null.",
            "id": "#annotation"
          },
          {
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "label": "Bam Output",
            "description": "File to which assembled haplotypes should be written Default value: null.",
            "id": "#bam_output"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "ALL_POSSIBLE_HAPLOTYPES",
                  "CALLED_HAPLOTYPES"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--bam-writer-type",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Bam Writer Type",
            "description": "Which haplotypes should be written to the BAM Default value: CALLED_HAPLOTYPES. Possible values: {ALL_POSSIBLE_HAPLOTYPES, CALLED_HAPLOTYPES}.",
            "id": "#bam_writer_type"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--comp",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Comp",
            "description": "Comparison VCF file(s) This argument may be specified 0 or more times. Default value: null.",
            "id": "#comp"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--consensus",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Consensus",
            "description": "Consensus mode Default value: false. Possible values: {true, false}.",
            "id": "#consensus"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--contamination-fraction-per-sample-file",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Contamination Fraction Per Sample File",
            "description": "Tab-separated File containing fraction of contamination in sequencing data (per sample) to aggressively remove. Format should be \"<SampleID><TAB><Contamination>\" (Contamination is double) per line; No header. Default value: null.",
            "id": "#contamination_fraction_per_sample_file"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--debug",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Debug",
            "description": "Print out very verbose debug information about each triggering active region Default value: false. Possible values: {true, false}.",
            "id": "#debug"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--disable-optimizations",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Disable Optimizations",
            "description": "Don't skip calculations in ActiveRegions with no variants Default value: false. Possible values: {true, false}.",
            "id": "#disable_optimizations"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--do-not-run-physical-phasing",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Do Not Run Physical Phasing",
            "description": "Disable physical phasing Default value: false. Possible values: {true, false}.",
            "id": "#do_not_run_physical_phasing"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--dont-increase-kmer-sizes-for-cycles",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Dont Increase Kmer Sizes For Cycles",
            "description": "Disable iterating over kmer sizes when graph cycles are detected Default value: false. Possible values: {true, false}.",
            "id": "#dont_increase_kmer_sizes_for_cycles"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--dont-trim-active-regions",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Dont Trim Active Regions",
            "description": "If specified, we will not trim down the active region from the full region (active + extension) to just the active interval for genotyping Default value: false. Possible values: {true, false}.",
            "id": "#dont_trim_active_regions"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--dont-use-soft-clipped-bases",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Dont Use Soft Clipped Bases",
            "description": "Do not analyze soft clipped bases in the reads Default value: false. Possible values: {true, false}.",
            "id": "#dont_use_soft_clipped_bases"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "NONE",
                  "BP_RESOLUTION",
                  "GVCF"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--emit-ref-confidence",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Emit Ref Confidence",
            "description": "Mode for emitting reference confidence scores Default value: NONE. Possible values: {NONE, BP_RESOLUTION, GVCF}.",
            "id": "#emit_ref_confidence"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--annotations-to-exclude",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Annotations To Exclude",
            "description": "One or more specific annotations to exclude from variant calls  This argument may be specified 0 or more times. Default value: null.",
            "id": "#annotations_to_exclude"
          },
          {
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--pair-hmm-gap-continuation-penalty",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Pair HMM Gap Continuation Penalty",
            "description": "Flat gap continuation penalty for use in the Pair HMM Default value: 10.",
            "id": "#pair_hmm_gap_continuation_penalty"
          },
          {
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--gvcf-gq-bands",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Gvcf GQ Bands",
            "description": "GQ thresholds for reference confidence bands This argument may be specified 0 or more times. Default value: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 70, 80, 90, 99].",
            "id": "#gvcf_gq_bands"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--indel-size-to-eliminate-in-ref-model",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Indel Size To Eliminate In Ref Model",
            "description": "The size of an indel to check for in the reference model Default value: 10.",
            "id": "#indel_size_to_eliminate_in_ref_model"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--input-prior",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Input Prior",
            "description": "Input prior for calls This argument may be specified 0 or more times. Default value: null.",
            "id": "#input_prior"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--kmer-size",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Kmer Size",
            "description": "Kmer size to use in the read threading assembler This argument may be specified 0 or more times. Default value: [10, 25].",
            "id": "#kmer_size"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-alternate-alleles",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Alternate Alleles",
            "description": "Maximum number of alternate alleles to genotype Default value: 6.",
            "id": "#max_alternate_alleles"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-genotype-count",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Genotype Count",
            "description": "Maximum number of genotypes to consider at any site Default value: 1024.",
            "id": "#max_genotype_count"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-num-haplotypes-in-population",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Num Haplotypes In Population",
            "description": "Maximum number of haplotypes to consider for your population Default value: 128.",
            "id": "#max_num_haplotypes_in_population"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-prob-propagation-distance",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Prob Propagation Distance",
            "description": "Upper limit on how many bases away probability mass can be moved around when calculating the boundaries between active and inactive assembly regions Default value: 50.",
            "id": "#max_prob_propagation_distance"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--min-dangling-branch-length",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Min Dangling Branch Length",
            "description": "Minimum length of a dangling branch to attempt recovery Default value: 4.",
            "id": "#min_dangling_branch_length"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--min-pruning",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Min Pruning",
            "description": "Minimum support to not prune paths in the graph Default value: 2.",
            "id": "#min_pruning"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--num-pruning-samples",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Num Pruning Samples",
            "description": "Number of samples that must pass the minPruning threshold Default value: 1.",
            "id": "#num_pruning_samples"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "NONE",
                  "HOSTILE",
                  "AGGRESSIVE",
                  "CONSERVATIVE"
                ],
                "name": "null"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--pcr-indel-model",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Pcr Indel Model",
            "description": "The PCR indel model to use Default value: CONSERVATIVE. Possible values: {NONE, HOSTILE, AGGRESSIVE, CONSERVATIVE}.",
            "id": "#pcr_indel_model"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--phred-scaled-global-read-mismapping-rate",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Phred Scaled Global Read Mismapping Rate",
            "description": "The global assumed mismapping rate for reads Default value: 45.",
            "id": "#phred_scaled_global_read_mismapping_rate"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--use-alleles-trigger",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Use Alleles Trigger",
            "description": "Use additional trigger on variants found in an external alleles file Default value: false. Possible values: {true, false}.",
            "id": "#use_alleles_trigger"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--use-filtered-reads-for-annotations",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Use Filtered Reads For Annotations",
            "description": "Use the contamination-filtered read maps for the purposes of annotating variants Default value: false. Possible values: {true, false}.",
            "id": "#use_filtered_reads_for_annotations"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--ambig-filter-frac",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Ambig Filter Frac",
            "description": "Threshold fraction of non-regular bases (e.g. N) above which to filter Default value: 0.05.",
            "id": "#ambig_filter_frac"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-fragment-length",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Fragment Length",
            "description": "Keep only read pairs with fragment length at most equal to the given value Default value: 1000000.",
            "id": "#max_fragment_length"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--library",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Library",
            "description": "The name of the library to keep Required.",
            "id": "#library"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--maximum-mapping-quality",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Maximum Mapping Quality",
            "description": "Maximum mapping quality to keep (inclusive) Default value: null.",
            "id": "#maximum_mapping_quality"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--minimum-mapping-quality",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Minimum Mapping Quality",
            "description": "Minimum mapping quality to keep (inclusive) Default value: 20.",
            "id": "#minimum_mapping_quality"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--dont-require-soft-clips-both-ends",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Dont Require Soft Clips Both Ends",
            "description": "Allow a read to be filtered out based on having only 1 soft-clipped block. By default, both ends must have a soft-clipped block, setting this flag requires only 1 soft-clipped block. Default value: false. Possible values: {true, false}.",
            "id": "#dont_require_soft_clips_both_ends"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--filter-too-short",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Filter Too Short",
            "description": "Value for which reads with less than this number of aligned bases is considered too short Default value: 30.",
            "id": "#filter_too_short"
          },
          {
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--platform-filter-name",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Platform Filter Name",
            "description": "Platform attribute (PL) to match. This argument must be specified at least once.",
            "id": "#platform_filter_name"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--black-listed-lanes",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Black Listed Lanes",
            "description": "Keep reads with platform units not on the list This argument must be specified at least once. Required.",
            "id": "#black_listed_lanes"
          },
          {
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--read-group-black-list",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Read Group Black List",
            "description": "This argument must be specified at least once. Required.",
            "id": "#read_group_black_list"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--keep-read-group",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Keep Read Group",
            "description": "The name of the read group to keep Required.",
            "id": "#keep_read_group"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--max-read-length",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Max Read Length",
            "description": "Keep only reads with length at most equal to the specified value Required.",
            "id": "#max_read_length"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--min-read-length",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Min Read Length",
            "description": "Keep only reads with length at least equal to the specified value Default value: 1.",
            "id": "#min_read_length"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--read-name",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Read Name",
            "description": "Keep only reads with this read name Required.",
            "id": "#read_name"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--keep-reverse",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Keep Reverse",
            "description": "Keep only reads on the reverse strand Required. Possible values: {true, false}.",
            "id": "#keep_reverse"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--sample",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Sample",
            "description": "The name of the sample(s) to keep, filtering out all others This argument must be specified at least once. Required.",
            "id": "#sample"
          },
          {
            "type": [
              "null",
              "int"
            ],
            "label": "Cpus Per Job",
            "description": "For tools which support multiprocessing, this value can be used to set the number of threads to be used. Set to 0 for auto-detect (use with caution,as auto-detect will find the optimal value in most cases).",
            "id": "#cpus_per_job"
          },
          {
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Memory Per Job",
            "description": "Amount of RAM memory to be used per job. Defaults to 2048MB for Single threaded jobs,and all of the available memory on the instance for multi-threaded jobs.",
            "id": "#memory_per_job"
          },
          {
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Memory Overhead Per Job",
            "description": "Memory overhead per job. By default this parameter value is set to '0' (zero megabytes). This parameter value is added to the Memory per job parameter value. This results in the allocation of the sum total (Memory per job and Memory overhead per job) amount of memory per job. By default the memory per job parameter value is set to 2048 megabytes, unless specified otherwise.",
            "id": "#memory_overhead_per_job"
          },
          {
            "sbg:toolDefaultValue": "FALSE",
            "sbg:stageInput": null,
            "type": [
              "null",
              "boolean"
            ],
            "label": "Include Interval Name In Output Name",
            "description": "Include interval name in output name.",
            "id": "#include_interval_name_in_output_name"
          },
          {
            "sbg:stageInput": "link",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "array",
                "items": "File"
              }
            ],
            "inputBinding": {
              "position": 0,
              "separate": false,
              "itemSeparator": " ",
              "valueFrom": {
                "class": "Expression",
                "script": "{\n  if($job.inputs.intervals_file){\n    if($job.inputs.intervals_file instanceof Array){\n      if($job.inputs.intervals_file.length > 1){\n        if([].concat($job.inputs.reads)[0].metadata)\n          if([].concat($job.inputs.reads)[0].metadata.intervals_file)\n            return '--intervals ' + [].concat($job.inputs.reads)[0].metadata.intervals_file\n      } else return '--intervals ' + [].concat($job.inputs.intervals_file)[0].path\n    } else return '--intervals ' + [].concat($job.inputs.intervals_file)[0].path\n  } else\n    return ''\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:cmdInclude": true
            },
            "label": "Intervals File",
            "description": "One or more genomic intervals over which to operate This argument may be specified 0 or more times. Default value: null.",
            "sbg:fileTypes": "TXT, BED",
            "id": "#intervals_file"
          },
          {
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--exclude-intervals",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Exclude Intervals File",
            "description": "One or more genomic intervals to exclude from processing This argument may be specified 0 or more times. Default value: null.",
            "sbg:fileTypes": "TXT, BED",
            "id": "#exclude_intervals_file"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--intervals",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Intervals String",
            "description": "One or more genomic intervals over which to operate This argument may be specified 0 or more times. Default value: null.",
            "id": "#intervals_string"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--exclude-intervals",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Exclude Intervals String",
            "description": "One or more genomic intervals to exclude from processing This argument may be specified 0 or more times. Default value: null.",
            "id": "#exclude_intervals_string"
          },
          {
            "sbg:stageInput": null,
            "sbg:altPrefix": "",
            "sbg:category": "Conditional Arguments for readFilter",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--ambig-filter-bases",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Ambig Filter Bases",
            "description": "Threshold number of ambiguous bases. If null, uses threshold fraction; otherwise, overrides threshold fraction. Cannot be used in conjunction with argument(s) maxAmbiguousBaseFraction.",
            "id": "#ambig_filter_bases"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "int"
            ],
            "label": "Wgs Hg38 Mode Memory",
            "description": "Set recommended value for memory if reference v38 is used",
            "id": "#wgs_hg38_mode_memory"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--activity-profile-out",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Activity Profile Out",
            "description": "Output the raw activity profile results in IGV format. Default value: null.",
            "id": "#activity_profile_out"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--annotation-group",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Annotation Group",
            "description": "One or more groups of annotations to apply to variant calls  This argument may be specified 0 or more times. Default value: [StandardAnnotation, StandardHCAnnotation].",
            "id": "#annotation_group"
          },
          {
            "sbg:stageInput": null,
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "ALL",
                  "OVERLAPPING_ONLY"
                ],
                "name": "interval_merging_rule"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--interval-merging-rule",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Interval Merging Rule",
            "description": "Interval merging rule for abutting intervals. Default value: ALL.",
            "id": "#interval_merging_rule"
          },
          {
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--native-pair-hmm-use-double-precision",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Native Pair Hmm Use Double Precision",
            "description": "Use double precision in the native pairHmm. This is slower but matches the java implementation better. Default value: false.",
            "id": "#native_pair_hmm_use_double_precision"
          },
          {
            "sbg:stageInput": null,
            "sbg:category": "Advanced Arguments",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "FASTEST_AVAILABLE",
                  "AVX_ENABLED",
                  "JAVA"
                ],
                "name": "smith_waterman"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--smith-waterman",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Smith-Waterman",
            "description": "Which Smith-Waterman implementation to use, generally FASTEST_AVAILABLE is the right choice  Default value: JAVA.",
            "id": "#smith_waterman"
          },
          {
            "sbg:stageInput": null,
            "sbg:category": "Optional Arguments",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--disable-tool-default-annotations",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Disable Tool Default Annotations",
            "description": "Disable all tool default annotations.",
            "id": "#disable_tool_default_annotations"
          },
          {
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "separate": true,
              "valueFrom": {
                "class": "Expression",
                "script": "{\n  if($job.inputs.dbsnp_gz)\n    return '--dbsnp ' + [].concat($job.inputs.dbsnp_gz)[0].path\n  else return ''\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:cmdInclude": true,
              "secondaryFiles": [
                ".tbi"
              ]
            },
            "label": "dbsnp gzipped",
            "description": "dbsnp gzipped",
            "sbg:fileTypes": "GZ",
            "id": "#dbsnp_gz"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "label": "VCF",
            "description": "A raw, unfiltered, highly specific callset in VCF format.",
            "sbg:fileTypes": "VCF",
            "outputBinding": {
              "glob": "*.vcf",
              "sbg:inheritMetadataFrom": "#reads",
              "secondaryFiles": [
                ".idx"
              ]
            },
            "id": "#output_vcf"
          },
          {
            "type": [
              "null",
              "File"
            ],
            "label": "Output BAM",
            "description": "Reassembled BAM outputted if the appropriate flag is set.",
            "sbg:fileTypes": "BAM",
            "outputBinding": {
              "glob": "*.bam",
              "sbg:inheritMetadataFrom": "#reads",
              "secondaryFiles": [
                ".bai"
              ]
            },
            "id": "#output_bam"
          }
        ],
        "requirements": [
          {
            "class": "ExpressionEngineRequirement",
            "requirements": [
              {
                "class": "DockerRequirement",
                "dockerPull": "rabix/js-engine"
              }
            ],
            "id": "#cwl-js-engine"
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": 1
          },
          {
            "class": "sbg:MemRequirement",
            "value": {
              "class": "Expression",
              "script": "{\n  memory = 0\n  \n  if($job.inputs.memory_per_job){\n  \t memory = $job.inputs.memory_per_job\n  }\n  else{\n    if($job.inputs.wgs_hg38_mode_memory){\n      \treference_name = $job.inputs.reference.path.replace(/^.*[\\\\\\/]/, '')\n      \n       \tif(reference_name.indexOf('38') >-1){\n      \t\tmemory = $job.inputs.wgs_hg38_mode_memory\n    \t}\n        else{\n       \t\tmemory = 2048 \n        }\n    }\n  \telse{\n       memory = 2048\n  \t}\n  }\n       \n  if($job.inputs.memory_overhead_per_job){\n\treturn memory + $job.inputs.memory_overhead_per_job  \n  }\n  else{\n  \treturn memory\n  }\n}",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "class": "DockerRequirement",
            "dockerImageId": "3c3b8e0ed4e5",
            "dockerPull": "images.sbgenomics.com/vladimirk/gatk:4.1.0.0"
          }
        ],
        "arguments": [
          {
            "position": 0,
            "prefix": "--output",
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\t\n  interval_name = ''\n  \n  if ($job.inputs.include_interval_name_in_output_name){\n    if($job.inputs.intervals_file){\n      interval_path = [].concat($job.inputs.intervals_file)[0].path\n      interval_name = interval_path.split('/')[interval_path.split('/').length - 1].split('.')\n      interval_name.pop()\n      interval_name = '_' + interval_name.join('')\n    }\n  }\n  \n  read_name = [].concat($job.inputs.reads)[0].path.replace(/^.*[\\\\\\/]/, '').split('.')\n  \n  if (read_name[read_name.length - 2] == 'recalibrated')\n  \tread_namebase = read_name.slice(0, read_name.length - 2).join('.')\n  else\n    read_namebase = read_name.slice(0, read_name.length - 1).join('.')\n   \n  if($job.inputs.emit_ref_confidence == 'GVCF')\n  \treturn read_namebase + interval_name + '.g.vcf'\n  else\n  \treturn read_namebase + interval_name +  '.vcf'\n}",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "position": 100,
            "prefix": "",
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  reads = [].concat($job.inputs.reads)\n  \n  if ($job.inputs.bam_output) {\n    \n    return '--bam-output ' + reads[0].path.split('/').pop().split('.').slice(0,-1).join('.') + '.reassembled.bam'\n    \n  } else {\n    \n    return ''\n    \n  }\n  \n}",
              "engine": "#cwl-js-engine"
            }
          }
        ],
        "sbg:toolkitVersion": "4.0.2.0",
        "sbg:image_url": null,
        "sbg:expand_workflow": false,
        "sbg:license": "Open source BSD (3-clause) license",
        "sbg:toolAuthor": "Broad Institute",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1501857597,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/24"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1501857597,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/25"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1501857597,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/26"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/27"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/28"
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/29"
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/33"
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/34"
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/35"
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/38"
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/39"
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/40"
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/41"
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/42"
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1505228734,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/45"
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1509555941,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/46"
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1509555941,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/49"
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1509555941,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/50"
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1515773678,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/51"
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1515773678,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/52"
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1515773678,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/64"
          },
          {
            "sbg:revision": 21,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1515773678,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/66"
          },
          {
            "sbg:revision": 22,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1515773678,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/70"
          },
          {
            "sbg:revision": 23,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1516984367,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/71"
          },
          {
            "sbg:revision": 24,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1516984367,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/72"
          },
          {
            "sbg:revision": 25,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1516984367,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/73"
          },
          {
            "sbg:revision": 26,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1516984367,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/74"
          },
          {
            "sbg:revision": 27,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1516984367,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/75"
          },
          {
            "sbg:revision": 28,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1519745521,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/76"
          },
          {
            "sbg:revision": 29,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1521477586,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/77"
          },
          {
            "sbg:revision": 30,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1521477586,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/78"
          },
          {
            "sbg:revision": 31,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1541284168,
            "sbg:revisionNotes": "Copy of vladimirk/whole-exome-pipeline-bwa-gatk-4-0-with-metrics-demo/GATK_HaplotypeCaller/79"
          },
          {
            "sbg:revision": 32,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1570720509,
            "sbg:revisionNotes": "Latest docker images.sbgenomics.com/vladimirk/gatk:4.1.0.0"
          },
          {
            "sbg:revision": 33,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1570720509,
            "sbg:revisionNotes": "bam_output removed from command line"
          }
        ],
        "sbg:links": [
          {
            "id": "https://software.broadinstitute.org/gatk/",
            "label": "Homepage"
          },
          {
            "id": "https://software.broadinstitute.org/gatk/documentation/tooldocs/current/",
            "label": "Documentation"
          },
          {
            "id": "https://software.broadinstitute.org/gatk/download/",
            "label": "Download"
          }
        ],
        "sbg:toolkit": "GATK",
        "sbg:job": {
          "allocatedResources": {
            "mem": 2048,
            "cpu": 1
          },
          "inputs": {
            "genotyping_mode": null,
            "db_snp": {
              "class": "File",
              "secondaryFiles": [
                {
                  "path": ".idx"
                }
              ],
              "path": "/path/to/db_snp.vcf",
              "size": 0
            },
            "bam_out": "",
            "exclude_ann": [
              ""
            ],
            "readShardPadding": null,
            "lenient": false,
            "createOutputVariantMD5": false,
            "kmer_size": null,
            "emitRefConfidence": null,
            "out_mode": null,
            "disable_opt": false,
            "max_haplotypes": null,
            "gq_threshold": [
              null
            ],
            "consensus": false,
            "use_jdk_deflater": false,
            "dontUseSoftClippedBases": false,
            "cpus_per_job": null,
            "use_jdk_inflater": false,
            "disableSequenceDictionaryValidation": false,
            "dontTrimActiveRegions": false,
            "maxTotalReadsInMemory": null,
            "debug": false,
            "dbsnp_gz": {
              "class": "File",
              "secondaryFiles": [
                {
                  "path": ".tbi"
                }
              ],
              "path": "/path/to/dbsnp_gz.ext",
              "size": 0
            },
            "graph_file": "",
            "min_base_q_scores": null,
            "include_interval_name_in_output_name": false,
            "QUIET": false,
            "no_active_region_trim": false,
            "smith_waterman": null,
            "intervals_file": [
              {
                "class": "File",
                "secondaryFiles": [],
                "path": "/path/to/1.bed",
                "size": 0
              }
            ],
            "max_genotype_count": null,
            "disable_phasing": false,
            "disable_tool_default_annotations": true,
            "annotation_group": "",
            "annotation_groups": [
              ""
            ],
            "addOutputSAMProgramRecord": false,
            "ambigFilterBases": null,
            "emitDroppedReads": false,
            "reads": [
              {
                "class": "File",
                "secondaryFiles": [],
                "path": "/path/to/input.bam",
                "size": 0
              }
            ],
            "memory_overhead_per_job": null,
            "force_active": false,
            "doNotRunPhysicalPhasing": false,
            "disableOptimizations": false,
            "dontIncreaseKmerSizesForCycles": false,
            "write_to_bam": null,
            "active_reg_ext": "",
            "min_reads_per_algn": null,
            "consensus_mode": false,
            "recoverDanglingHeads": false,
            "interval_merging_rule": null,
            "max_active_region_size": null,
            "dontRequireSoftClipsBothEnds": false,
            "min_pruning_threshold": "",
            "reference": {
              "class": "File",
              "secondaryFiles": [
                {
                  "path": ".fai"
                },
                {
                  "path": "^.dict"
                }
              ],
              "path": "/path/to/reference.fa",
              "size": 0
            },
            "bamout": false,
            "no_soft_clipped": false,
            "wgs_hg38_mode_memory": null,
            "dont_increase_kmers": false,
            "annotateNDA": false,
            "no_cmdline_in_header": false,
            "active_reg_output_file_name": "",
            "readShardSize": null,
            "output_raw_activity": "",
            "useFilteredReadsForAnnotations": false,
            "heterozygosityStandardDeviation": null,
            "band_pass": "",
            "mismapping_rate": null,
            "createOutputBamMD5": false,
            "createOutputVariantIndex": false,
            "keepReverse": false,
            "exclude_intervals_string": "",
            "use_filtered_reads": false,
            "allowNonUniqueKmersInRef": false,
            "sample_name": "",
            "contamination_fraction": null,
            "prob_threshold": null,
            "gap_penalty": null,
            "use_allele_trigger": false,
            "min_length": null,
            "createOutputBamIndex": false,
            "native_pair_hmm_use_double_precision": false,
            "disableBamIndexCaching": false,
            "pcr_indel_model": null,
            "useAllelesTrigger": false,
            "maxReadsInMemoryPerSample": null,
            "intervals_string": "",
            "activity_profile_out": "",
            "indel_size": null,
            "useDoublePrecision": false,
            "allSitePLs": false,
            "bqsr": {
              "class": "File",
              "secondaryFiles": [],
              "path": "/path/to/bqsr.ext",
              "size": 0
            },
            "max_reads_active_reg": null,
            "secondsBetweenProgressUpdates": null,
            "min_graph_pruning": "",
            "memory_per_job": null,
            "disableToolDefaultReadFilters": false,
            "bamOutput": false,
            "emit_ref_confidence": "GVCF",
            "annotate_all_sites_PLs": false,
            "useNewAFCalculator": false,
            "allow_non_unique_kmers": false
          }
        },
        "sbg:projectName": "SBG Public data",
        "sbg:cmdPreview": "/gatk/gatk --java-options \"-Xmx2048M\" HaplotypeCaller --input /path/to/input.bam --reference /path/to/reference.fa --output input.g.vcf",
        "sbg:categories": [
          "GATK-4"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:id": "admin/sbg-public-data/gatk-4-0-haplotypecaller/33",
        "sbg:revision": 33,
        "sbg:revisionNotes": "bam_output removed from command line",
        "sbg:modifiedOn": 1570720509,
        "sbg:modifiedBy": "admin",
        "sbg:createdOn": 1501857597,
        "sbg:createdBy": "admin",
        "sbg:project": "admin/sbg-public-data",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "admin"
        ],
        "sbg:latestRevision": 33,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "aad63f3e856bcac1b343b3a3d894666cccb47e84415f11ee2a808bb415533ff21"
      },
      "label": "GATK HaplotypeCaller",
      "sbg:x": 42.25,
      "sbg:y": 52.650001525878906
    },
    {
      "id": "bwa_mem_bundle_0_7_17",
      "in": [
        {
          "id": "reference_index_tar",
          "source": "bwa_index_0_7_17/indexed_reference"
        },
        {
          "id": "input_reads",
          "source": [
            "input_reads"
          ]
        },
        {
          "id": "deduplication",
          "source": "deduplication"
        }
      ],
      "out": [
        {
          "id": "aligned_reads"
        },
        {
          "id": "dups_metrics"
        }
      ],
      "run": {
        "cwlVersion": "sbg:draft-2",
        "class": "CommandLineTool",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "id": "admin/sbg-public-data/bwa-mem-bundle-0-7-17/44",
        "label": "BWA MEM Bundle 0.7.17",
        "description": "**BWA-MEM** is an algorithm designed for aligning sequence reads onto a large reference genome. BWA-MEM is implemented as a component of BWA. The algorithm can automatically choose between performing end-to-end and local alignments. BWA-MEM is capable of outputting multiple alignments, and finding chimeric reads. It can be applied to a wide range of read lengths, from 70 bp to several megabases. \n\n## Common Use Cases\nIn order to obtain possibilities for additional fast processing of aligned reads, **Biobambam2 sortmadup** (2.0.87) tool is embedded together into the same package with BWA-MEM (0.7.17).\nIf deduplication of alignments is needed, it can be done by setting the parameter 'Duplication'. Biobambam2 sortmadup will be used internally to perform this action.\n\nBesides the standard BWA-MEM SAM output file, BWA-MEM package has been extended to support additional output options enabled by Biobambam2 sortmadup: BAM file, Coordinate Sorted BAM along with accompanying .bai file, queryname sorted BAM and CRAM. Sorted BAM is the default output of BWA-MEM. Parameter responsible for output type selection is *Output format*. Passing data from BWA-MEM to Biobambam2 sortmadup tool has been done through the linux pipes which saves processing times (up to an hour of the execution time for whole genome sample) of two read and write of aligned reads into the hard drive.\n\n## Common Issues and Important Notes\nFor input reads fastq files of total size less than 10 GB we suggest using the default setting for parameter 'total memory' of 15GB, for larger files we suggest using 58 GB of memory and 32 CPU cores.\n\nIn order to work BWA-MEM Bundle requires fasta reference file accompanied with **BWA Fasta indices** in TAR file.\n\nHuman reference genome version 38 comes with ALT contigs, a collection of diverged alleles present in some humans but not the others. Making effective use of these contigs will help to reduce mapping artifacts, however, to facilitate mapping these ALT contigs to the primary assembly, GRC decided to add to each contig long flanking sequences almost identical to the primary assembly. As a result, a naive mapping against GRCh38+ALT will lead to many mapQ-zero mappings in these flanking regions. Please use post-processing steps to fix these alignments or implement [steps](https://sourceforge.net/p/bio-bwa/mailman/message/32845712/) described by the author of BWA toolkit.\n\nWhen desired output is CRAM file without deduplication of the PCR duplicates, it is necessary to provide FASTA Index file as input.\n\nIf __Read group ID__ parameter is not defined, by default it will  be set to \u20181\u2019. If the tool is scattered within a workflow it will assign the Read Group ID according to the order of the scattered folders. This ensures a unique Read Group ID when when processing multi-read group input data from one sample.",
        "baseCommand": [
          {
            "script": "{\n  cmd = \"/bin/bash -c \\\"\"\n  return cmd + \" export REF_CACHE=${PWD} ; \"\n}",
            "engine": "#cwl-js-engine",
            "class": "Expression"
          },
          {
            "script": "{\n  reference_file = $job.inputs.reference_index_tar.path.split('/')[$job.inputs.reference_index_tar.path.split('/').length-1]\n  return 'tar -tvf ' +  reference_file + ' 1>&2; tar -xf ' + reference_file + ' ; '\n  \n}",
            "engine": "#cwl-js-engine",
            "class": "Expression"
          },
          "bwa",
          "mem"
        ],
        "inputs": [
          {
            "sbg:stageInput": "link",
            "sbg:category": "Input files",
            "type": [
              "File"
            ],
            "label": "Reference Index TAR",
            "description": "Reference fasta file with BWA index files packed in TAR.",
            "sbg:fileTypes": "TAR",
            "id": "#reference_index_tar"
          },
          {
            "sbg:stageInput": "link",
            "sbg:category": "Input files",
            "type": [
              {
                "type": "array",
                "items": "File"
              }
            ],
            "label": "Input reads",
            "description": "Input sequence reads.",
            "sbg:fileTypes": "FASTQ, FASTQ.GZ, FQ, FQ.GZ",
            "id": "#input_reads"
          },
          {
            "sbg:toolDefaultValue": "8",
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Threads",
            "description": "Number of threads for BWA, Samblaster and Sambamba sort process.",
            "id": "#threads"
          },
          {
            "sbg:toolDefaultValue": "19",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-k",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Minimum seed length",
            "description": "Minimum seed length for BWA MEM.",
            "id": "#minimum_seed_length"
          },
          {
            "sbg:toolDefaultValue": "100",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-d",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Dropoff",
            "description": "Off-diagonal X-dropoff.",
            "id": "#dropoff"
          },
          {
            "sbg:toolDefaultValue": "1.5",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-r",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Select seeds",
            "description": "Look for internal seeds inside a seed longer than {-k} * FLOAT.",
            "id": "#select_seeds"
          },
          {
            "sbg:toolDefaultValue": "20",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-y",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Seed occurrence for the 3rd round",
            "description": "Seed occurrence for the 3rd round seeding.",
            "id": "#seed_occurrence_for_the_3rd_round"
          },
          {
            "sbg:toolDefaultValue": "500",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-c",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Skip seeds with more than INT occurrences",
            "description": "Skip seeds with more than INT occurrences.",
            "id": "#skip_seeds"
          },
          {
            "sbg:toolDefaultValue": "0.50",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "float"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-D",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Drop chains fraction",
            "description": "Drop chains shorter than FLOAT fraction of the longest overlapping chain.",
            "id": "#drop_chains_fraction"
          },
          {
            "sbg:toolDefaultValue": "0",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-W",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Discard chain length",
            "description": "Discard a chain if seeded bases shorter than INT.",
            "id": "#discard_chain_length"
          },
          {
            "sbg:toolDefaultValue": "50",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-m",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Mate rescue rounds",
            "description": "Perform at most INT rounds of mate rescues for each read.",
            "id": "#mate_rescue_rounds"
          },
          {
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-S",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Skip mate rescue",
            "description": "Skip mate rescue.",
            "id": "#skip_mate_rescue"
          },
          {
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-P",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Skip pairing",
            "description": "Skip pairing; mate rescue performed unless -S also in use.",
            "id": "#skip_pairing"
          },
          {
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-e",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Discard exact matches",
            "description": "Discard full-length exact matches.",
            "id": "#discard_exact_matches"
          },
          {
            "sbg:toolDefaultValue": "1",
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-A",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Score for a sequence match",
            "description": "Score for a sequence match, which scales options -TdBOELU unless overridden.",
            "id": "#score_for_a_sequence_match"
          },
          {
            "sbg:toolDefaultValue": "4",
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-B",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Mismatch penalty",
            "description": "Penalty for a mismatch.",
            "id": "#mismatch_penalty"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-p",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Smart pairing in input FASTQ file",
            "description": "Smart pairing in input FASTQ file (ignoring in2.fq).",
            "id": "#smart_pairing_in_input_fastq"
          },
          {
            "sbg:toolDefaultValue": "Constructed from per-attribute parameters or inferred from metadata.",
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              "string"
            ],
            "label": "Read group header",
            "description": "Read group header line such as '@RG\\tID:foo\\tSM:bar'.  This value takes precedence over per-attribute parameters.",
            "id": "#read_group_header"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-H",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Insert string to output SAM or BAM header",
            "description": "Insert STR to header if it starts with @; or insert lines in FILE.",
            "id": "#insert_string_to_header"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-j",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Ignore ALT file",
            "description": "Treat ALT contigs as part of the primary assembly (i.e. ignore <idxbase>.alt file).",
            "id": "#ignore_alt_file"
          },
          {
            "sbg:toolDefaultValue": "3",
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "1",
                  "2",
                  "3",
                  "4"
                ],
                "name": "verbose_level"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-v",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Verbose level",
            "description": "Verbose level: 1=error, 2=warning, 3=message, 4+=debugging.",
            "id": "#verbose_level"
          },
          {
            "sbg:toolDefaultValue": "30",
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-T",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Minimum alignment score for a read to be output in SAM/BAM",
            "description": "Minimum alignment score for a read to be output in SAM/BAM.",
            "id": "#minimum_output_score"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-a",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Output alignments",
            "description": "Output all alignments for SE or unpaired PE.",
            "id": "#output_alignments"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-C",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Append comment",
            "description": "Append FASTA/FASTQ comment to SAM output.",
            "id": "#append_comment"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-V",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Output header",
            "description": "Output the reference FASTA header in the XR tag.",
            "id": "#output_header"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-Y",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Use soft clipping",
            "description": "Use soft clipping for supplementary alignments.",
            "id": "#use_soft_clipping"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-M",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Mark shorter",
            "description": "Mark shorter split hits as secondary.",
            "id": "#mark_shorter"
          },
          {
            "sbg:toolDefaultValue": "[6,6]",
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              {
                "type": "array",
                "items": "int"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-O",
              "separate": false,
              "itemSeparator": ",",
              "sbg:cmdInclude": true
            },
            "label": "Gap open penalties",
            "description": "Gap open penalties for deletions and insertions. This array can't have more than two values.",
            "id": "#gap_open_penalties"
          },
          {
            "sbg:toolDefaultValue": "[1,1]",
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              {
                "type": "array",
                "items": "int"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-E",
              "separate": false,
              "itemSeparator": ",",
              "sbg:cmdInclude": true
            },
            "label": "Gap extension",
            "description": "Gap extension penalty; a gap of size k cost '{-O} + {-E}*k'. This array can't have more than two values.",
            "id": "#gap_extension_penalties"
          },
          {
            "sbg:toolDefaultValue": "[5,5]",
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              {
                "type": "array",
                "items": "int"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-L",
              "separate": false,
              "itemSeparator": ",",
              "sbg:cmdInclude": true
            },
            "label": "Clipping penalty",
            "description": "Penalty for 5'- and 3'-end clipping.",
            "id": "#clipping_penalty"
          },
          {
            "sbg:toolDefaultValue": "17",
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-U",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Unpaired read penalty",
            "description": "Penalty for an unpaired read pair.",
            "id": "#unpaired_read_penalty"
          },
          {
            "sbg:category": "BWA Scoring options",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "pacbio",
                  "ont2d",
                  "intractg"
                ],
                "name": "read_type"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-x",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Sequencing technology-specific settings",
            "description": "Sequencing technology-specific settings; Setting -x changes multiple parameters unless overriden. pacbio: -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0  (PacBio reads to ref). ont2d: -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0  (Oxford Nanopore 2D-reads to ref). intractg: -B9 -O16 -L5  (intra-species contigs to ref).",
            "id": "#read_type"
          },
          {
            "sbg:toolDefaultValue": "[5, 200]",
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              {
                "type": "array",
                "items": "int"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-h",
              "separate": false,
              "itemSeparator": ",",
              "sbg:cmdInclude": true
            },
            "label": "Output in XA",
            "description": "If there are <INT hits with score >80% of the max score, output all in XA. This array should have no more than two values.",
            "id": "#output_in_xa"
          },
          {
            "sbg:category": "BWA Input/output options",
            "type": [
              "null",
              {
                "type": "array",
                "items": "float"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-I",
              "separate": false,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Specify distribution parameters",
            "description": "Specify the mean, standard deviation (10% of the mean if absent), max (4 sigma from the mean if absent) and min of the insert size distribution.FR orientation only. This array can have maximum four values, where first two should be specified as FLOAT and last two as INT.",
            "id": "#speficy_distribution_parameters"
          },
          {
            "sbg:toolDefaultValue": "100",
            "sbg:category": "BWA Algorithm options",
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-w",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Band width",
            "description": "Band width for banded alignment.",
            "id": "#band_width"
          },
          {
            "sbg:toolDefaultValue": "Inferred from metadata",
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "454",
                  "Helicos",
                  "Illumina",
                  "Solid",
                  "IonTorrent"
                ],
                "name": "rg_platform"
              }
            ],
            "label": "Platform",
            "description": "Specify the version of the technology that was used for sequencing, which will be placed in RG line.",
            "id": "#rg_platform"
          },
          {
            "sbg:toolDefaultValue": "Inferred from metadata",
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              "string"
            ],
            "label": "Sample ID",
            "description": "Specify the sample ID for RG line - A human readable identifier for a sample or specimen, which could contain some metadata information. A sample or specimen is material taken from a biological entity for testing, diagnosis, propagation, treatment, or research purposes, including but not limited to tissues, body fluids, cells, organs, embryos, body excretory products, etc.",
            "id": "#rg_sample_id"
          },
          {
            "sbg:toolDefaultValue": "Inferred from metadata",
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              "string"
            ],
            "label": "Library ID",
            "description": "Specify the identifier for the sequencing library preparation, which will be placed in RG line.",
            "id": "#rg_library_id"
          },
          {
            "sbg:toolDefaultValue": "Inferred from metadata",
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              "string"
            ],
            "label": "Platform unit ID",
            "description": "Specify the platform unit (lane/slide) for RG line - An identifier for lanes (Illumina), or for slides (SOLiD) in the case that a library was split and ran over multiple lanes on the flow cell or slides.",
            "id": "#rg_platform_unit_id"
          },
          {
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              "string"
            ],
            "label": "Data submitting center",
            "description": "Specify the data submitting center for RG line.",
            "id": "#rg_data_submitting_center"
          },
          {
            "sbg:category": "BWA Read Group Options",
            "type": [
              "null",
              "string"
            ],
            "label": "Median fragment length",
            "description": "Specify the median fragment length for RG line.",
            "id": "#rg_median_fragment_length"
          },
          {
            "sbg:toolDefaultValue": "Coordinate Sorted BAM",
            "sbg:category": "Execution",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "SAM",
                  "BAM",
                  "CRAM",
                  "Queryname Sorted BAM",
                  "Queryname Sorted SAM",
                  "Coordinate Sorted BAM"
                ],
                "name": "output_format"
              }
            ],
            "label": "Output format",
            "description": "Cordinate sort is default output.",
            "id": "#output_format"
          },
          {
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Memory for BAM sorting",
            "description": "Amount of RAM [Gb] to give to the sorting algorithm (if not provided will be set to one third of the total memory).",
            "id": "#sort_memory"
          },
          {
            "sbg:category": "Biobambam2 parameters",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "None",
                  "MarkDuplicates",
                  "RemoveDuplicates"
                ],
                "name": "deduplication"
              }
            ],
            "label": "PCR duplicate detection",
            "description": "Use Biobambam2 for finding duplicates on sequence reads.",
            "id": "#deduplication"
          },
          {
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "15",
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Total memory",
            "description": "Total memory to be used by the tool in GB. It's sum of BWA, Sambamba Sort and Samblaster. For fastq files of total size less than 10GB, we suggest using the default setting of 15GB, for larger files we suggest using 58GB of memory (and 32CPU cores).",
            "id": "#total_memory"
          },
          {
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "False",
            "sbg:category": "Execution",
            "type": [
              "null",
              "boolean"
            ],
            "label": "Filter out secondary alignments",
            "description": "Filter out secondary alignments. Sambamba view tool will be used to perform this internally.",
            "id": "#filter_out_secondary_alignments"
          },
          {
            "sbg:category": "Configuration",
            "type": [
              "null",
              "string"
            ],
            "label": "Output SAM/BAM file name",
            "description": "Name of the output BAM file.",
            "id": "#output_name"
          },
          {
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "1",
            "sbg:category": "Configuration",
            "type": [
              "null",
              "int"
            ],
            "label": "Reserved number of threads on the instance",
            "description": "Reserved number of threads on the instance used by scheduler.",
            "id": "#reserved_threads"
          },
          {
            "sbg:toolDefaultValue": "1",
            "sbg:category": "Configuration",
            "type": [
              "null",
              "string"
            ],
            "label": "Read group ID",
            "description": "Read group ID",
            "id": "#rg_id"
          },
          {
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "False",
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Optimize threads for HG38",
            "description": "Lower the number of threads if HG38 reference genome is used.",
            "id": "#wgs_hg38_mode_threads"
          },
          {
            "sbg:stageInput": null,
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-5",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Split alignment smallest coordinate as primary",
            "description": "for split alignment, take the alignment with the smallest coordinate as primary.",
            "id": "#split_alignment_primary"
          },
          {
            "sbg:stageInput": null,
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-q",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "Don't modify mapQ of supplementary alignments",
            "description": "Don't modify mapQ of supplementary alignments",
            "id": "#mapQ_of_suplementary"
          },
          {
            "sbg:stageInput": null,
            "type": [
              "null",
              "int"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-K",
              "separate": true,
              "itemSeparator": "null",
              "sbg:cmdInclude": true
            },
            "label": "process INT input bases in each batch (for reproducibility)",
            "description": "process INT input bases in each batch regardless of nThreads (for reproducibility)",
            "id": "#num_input_bases_in_each_batch"
          },
          {
            "sbg:stageInput": "copy",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 4,
              "separate": true,
              "itemSeparator": "null",
              "valueFrom": {
                "script": "{\n    return \"\";\n}",
                "engine": "#cwl-js-engine",
                "class": "Expression"
              }
            },
            "label": "Fasta Index file for CRAM output",
            "description": "Fasta index file is required for CRAM output when no PCR Deduplication is selected.",
            "sbg:fileTypes": "FAI",
            "id": "#fasta_index"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "label": "Aligned SAM/BAM",
            "description": "Aligned reads.",
            "sbg:fileTypes": "SAM, BAM, CRAM",
            "outputBinding": {
              "glob": "{*.sam,*.bam,*.cram}",
              "sbg:metadata": {
                "reference_genome": {
                  "script": "{\n  reference_file = $job.inputs.reference_index_tar.path.split('/')[$job.inputs.reference_index_tar.path.split('/').length-1]\n  name = reference_file.slice(0, -4) // cut .tar extension \n  \n  name_list = name.split('.')\n  ext = name_list[name_list.length-1]\n\n  if (ext == 'gz' || ext == 'GZ'){\n    a = name_list.pop() // strip fasta.gz\n    a = name_list.pop()\n  } else\n    a = name_list.pop() //strip only fasta/fa\n  \n  return name_list.join('.')\n  \n}",
                  "engine": "#cwl-js-engine",
                  "class": "Expression"
                }
              },
              "sbg:inheritMetadataFrom": "#input_reads",
              "secondaryFiles": [
                ".bai",
                "^.bai",
                ".crai",
                "^.crai"
              ]
            },
            "id": "#aligned_reads"
          },
          {
            "type": [
              "null",
              "File"
            ],
            "label": "Sormadup metrics",
            "description": "Metrics file for biobambam mark duplicates",
            "sbg:fileTypes": "LOG",
            "outputBinding": {
              "glob": "*.sormadup_metrics.log"
            },
            "id": "#dups_metrics"
          }
        ],
        "requirements": [
          {
            "class": "ExpressionEngineRequirement",
            "id": "#cwl-js-engine",
            "requirements": [
              {
                "class": "DockerRequirement",
                "dockerPull": "rabix/js-engine"
              }
            ]
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": {
              "script": "{  \n  // Calculate suggested number of CPUs depending of the input reads size\n  if ($job.inputs.input_reads.constructor == Array){\n    if ($job.inputs.input_reads[1]){\n      reads_size = $job.inputs.input_reads[0].size + $job.inputs.input_reads[1].size\n    } else{\n      reads_size = $job.inputs.input_reads[0].size\n    }\n  }\n  else{\n    reads_size = $job.inputs.input_reads.size\n  }\n  if(!reads_size) { reads_size = 0 }\n\n\n  GB_1 = 1024*1024*1024\n  if(reads_size < GB_1){ suggested_cpus = 1 }\n  else if(reads_size < 10 * GB_1){ suggested_cpus = 8 }\n  else { suggested_cpus = 31 }\n  \n  if($job.inputs.reserved_threads){ return $job.inputs.reserved_threads }\n  else if($job.inputs.threads){ return $job.inputs.threads } \n  else if($job.inputs.sambamba_threads) { return $job.inputs.sambamba_threads }\n  else{    return suggested_cpus  }\n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "class": "sbg:MemRequirement",
            "value": {
              "script": "{  \n\n  // Calculate suggested number of CPUs depending of the input reads size\n  if ($job.inputs.input_reads.constructor == Array){\n    if ($job.inputs.input_reads[1]){\n      reads_size = $job.inputs.input_reads[0].size + $job.inputs.input_reads[1].size\n    } else{\n      reads_size = $job.inputs.input_reads[0].size\n    }\n  }\n  else{\n    reads_size = $job.inputs.input_reads.size\n  }\n  if(!reads_size) { reads_size = 0 }\n \n  GB_1 = 1024*1024*1024\n  if(reads_size < GB_1){ suggested_memory = 4 }\n  else if(reads_size < 10 * GB_1){ suggested_memory = 15 }\n  else { suggested_memory = 58 }\n  \n  if($job.inputs.total_memory){  \t\n    return  $job.inputs.total_memory* 1024  \n  } \n  else if($job.inputs.sort_memory){\n    return  $job.inputs.sort_memory* 1024\n  }\n  else{  \t\n    return suggested_memory * 1024  \n  }\n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "class": "DockerRequirement",
            "dockerPull": "images.sbgenomics.com/vladimirk/bwa_biobambam2:0.7.17"
          }
        ],
        "arguments": [
          {
            "position": 112,
            "prefix": "",
            "separate": false,
            "itemSeparator": "null",
            "valueFrom": {
              "script": "{\n  ///////////////////////////////////////////\n ///  BIOBAMBAM BAMSORMADUP   //////////////////////\n///////////////////////////////////////////\n  \nfunction common_substring(a,b) {\n  var i = 0;\n  while(a[i] === b[i] && i < a.length)\n  {\n    i = i + 1;\n  }\n\n  return a.slice(0, i);\n}\n\n   // Set output file name\n  if($job.inputs.input_reads[0] instanceof Array){\n    input_1 = $job.inputs.input_reads[0][0] // scatter mode\n    input_2 = $job.inputs.input_reads[0][1]\n  } else if($job.inputs.input_reads instanceof Array){\n    input_1 = $job.inputs.input_reads[0]\n    input_2 = $job.inputs.input_reads[1]\n  }else {\n    input_1 = [].concat($job.inputs.input_reads)[0]\n    input_2 = input_1\n  }\n  full_name = input_1.path.split('/')[input_1.path.split('/').length-1] \n  \n  if($job.inputs.output_name){name = $job.inputs.output_name }\n  else if ($job.inputs.input_reads.length == 1){\n    name = full_name\n    if(name.slice(-3, name.length) === '.gz' || name.slice(-3, name.length) === '.GZ')\n      name = name.slice(0, -3)   \n    if(name.slice(-3, name.length) === '.fq' || name.slice(-3, name.length) === '.FQ')\n      name = name.slice(0, -3)\n    if(name.slice(-6, name.length) === '.fastq' || name.slice(-6, name.length) === '.FASTQ')\n      name = name.slice(0, -6)\n       \n  }else{\n    full_name2 = input_2.path.split('/')[input_2.path.split('/').length-1] \n    name = common_substring(full_name, full_name2)\n    \n    if(name.slice(-1, name.length) === '_' || name.slice(-1, name.length) === '.')\n      name = name.slice(0, -1)\n    if(name.slice(-2, name.length) === 'p_' || name.slice(-1, name.length) === 'p.')\n      name = name.slice(0, -2)\n    if(name.slice(-2, name.length) === 'P_' || name.slice(-1, name.length) === 'P.')\n      name = name.slice(0, -2)\n    if(name.slice(-3, name.length) === '_p_' || name.slice(-3, name.length) === '.p.')\n      name = name.slice(0, -3)\n    if(name.slice(-3, name.length) === '_pe' || name.slice(-3, name.length) === '.pe')\n      name = name.slice(0, -3)\n  }\n\n  //////////////////////////\n  // Set sort memory size\n  \n  reads_size = 0 // Not used because of situations when size does not exist!\n  GB_1 = 1024*1024*1024\n  if(reads_size < GB_1){ \n    suggested_memory = 4\n    suggested_cpus = 1\n  }\n  else if(reads_size < 10 * GB_1){ \n    suggested_memory = 15\n    suggested_cpus = 8\n  }\n  else { \n    suggested_memory = 58 \n    suggested_cpus = 31\n  }\n  \n  \n  if(!$job.inputs.total_memory){ total_memory = suggested_memory }\n  else{ total_memory = $job.inputs.total_memory }\n\n  // TODO:Rough estimation, should be fine-tuned!\n  if(total_memory > 16){ sorter_memory = parseInt(total_memory / 3) }\n  else{ sorter_memory = 5 }\n          \n  if ($job.inputs.sort_memory){\n    sorter_memory_string = $job.inputs.sort_memory +'GiB'\n  }\n  else sorter_memory_string = sorter_memory + 'GiB' \n  \n  // Read number of threads if defined\n  if ($job.inputs.threads){\n    threads = $job.inputs.threads\n  }\n  else if ($job.inputs.wgs_hg38_mode_threads){\n    MAX_THREADS = 36\n    ref_name_arr = $job.inputs.reference_index_tar.path.split('/')\n    ref_name = ref_name_arr[ref_name_arr.length - 1]\n    if (ref_name.search('38') >= 0){threads = $job.inputs.wgs_hg38_mode_threads}\n    else {threads = MAX_THREADS}\n  }\n  else { threads = 8 }\n  \n  \n  \nif ($job.inputs.deduplication == \"MarkDuplicates\") {\n    tool = 'bamsormadup'\n    dedup = ' markduplicates=1'\n} else {\n    if ($job.inputs.output_format == 'CRAM') {\n        tool = 'bamsort index=0'\n    } else {\n        tool = 'bamsort index=1'\n    }\n    if ($job.inputs.deduplication == \"RemoveDuplicates\") {\n        dedup = ' rmdup=1'\n    } else {\n        dedup = ''\n    }\n}\nsort_path = tool + dedup\n  \n  indexfilename = ' '\n  // Coordinate Sorted BAM is default\n  if ($job.inputs.output_format == 'CRAM'){\n    out_format = ' outputformat=cram SO=coordinate'\n    ref_name_arr = $job.inputs.reference_index_tar.path.split('/')\n    ref_name = ref_name_arr[ref_name_arr.length - 1].split('.tar')[0]\n    out_format += ' reference=' + ref_name\n    if (sort_path != 'bamsort index=0') {\n            indexfilename = ' indexfilename=' + name + '.cram.crai'\n        }\n    extension = '.cram'    \n  }else if($job.inputs.output_format == 'SAM'){\n    out_format = ' outputformat=sam SO=coordinate'\n    extension = '.sam'    \n  }else if ($job.inputs.output_format == 'Queryname Sorted BAM'){\n    out_format = ' outputformat=bam SO=queryname'\n    extension = '.bam'\n  }else if ($job.inputs.output_format == 'Queryname Sorted SAM'){\n    out_format = ' outputformat=sam SO=queryname'\n    extension = '.sam'    \n  }else {\n    out_format = ' outputformat=bam SO=coordinate'\n    indexfilename = ' indexfilename=' + name + '.bam.bai'\n    extension = '.bam'\n  }\n    cmd = \" | \" + sort_path + \" threads=\" + threads + \" level=1 tmplevel=-1 inputformat=sam\" \n    cmd += out_format\n    cmd += indexfilename\n    // capture metrics file\n    cmd += \" M=\" + name + \".sormadup_metrics.log\"\n    \n    if($job.inputs.output_format == 'SAM'){\n        cmd = ''\n    }\n    return cmd + ' > ' + name + extension\n\n}\n  \n",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "position": 1,
            "prefix": "",
            "separate": true,
            "valueFrom": {
              "script": "{\n  \n  if($job.inputs.read_group_header){\n  \treturn '-R ' + $job.inputs.read_group_header\n  }\n    \n  function add_param(key, val){\n    if(!val){\n      return\n\t}\n    param_list.push(key + ':' + val)\n  }\n\n  param_list = []\n\n  // Set output file name\n  if($job.inputs.input_reads[0] instanceof Array){\n    input_1 = $job.inputs.input_reads[0][0] // scatter mode\n  } else if($job.inputs.input_reads instanceof Array){\n    input_1 = $job.inputs.input_reads[0]\n  }else {\n    input_1 = [].concat($job.inputs.input_reads)[0]\n  }\n  \n  //Read metadata for input reads\n  read_metadata = input_1.metadata\n  if(!read_metadata) read_metadata = []\n  \n  // Used for scatter mode\n  var folder = input_1.path.split('/').slice(-2,-1).toString();\n  var suffix = \"_s\"\n \n  if($job.inputs.rg_id){\n    add_param('ID', $job.inputs.rg_id)\n  } else if (folder.indexOf(suffix, folder.length - suffix.length) !== -1) { // scatter mode\n        var rg = folder.split(\"_\").slice(-2)[0]\n        if (parseInt(rg)) add_param('ID', rg)\n        else add_param('ID', 1)\n    }\n  else {\n    add_param('ID', '1')\n  } \n   \n  \n  if($job.inputs.rg_data_submitting_center){\n  \tadd_param('CN', $job.inputs.rg_data_submitting_center)\n  }\n  else if('data_submitting_center' in  read_metadata){\n  \tadd_param('CN', read_metadata.data_submitting_center)\n  }\n  \n  if($job.inputs.rg_library_id){\n  \tadd_param('LB', $job.inputs.rg_library_id)\n  }\n  else if('library_id' in read_metadata){\n  \tadd_param('LB', read_metadata.library_id)\n  }\n  \n  if($job.inputs.rg_median_fragment_length){\n  \tadd_param('PI', $job.inputs.rg_median_fragment_length)\n  }\n\n  \n  if($job.inputs.rg_platform){\n  \tadd_param('PL', $job.inputs.rg_platform)\n  }\n  else if('platform' in read_metadata){\n    if(read_metadata.platform == 'HiSeq X Ten'){\n      rg_platform = 'Illumina'\n    }\n    else{\n      rg_platform = read_metadata.platform\n    }\n  \tadd_param('PL', rg_platform)\n  }\n  \n  if($job.inputs.rg_platform_unit_id){\n  \tadd_param('PU', $job.inputs.rg_platform_unit_id)\n  }\n  else if('platform_unit_id' in read_metadata){\n  \tadd_param('PU', read_metadata.platform_unit_id)\n  }\n  \n  if($job.inputs.rg_sample_id){\n  \tadd_param('SM', $job.inputs.rg_sample_id)\n  }\n  else if('sample_id' in  read_metadata){\n  \tadd_param('SM', read_metadata.sample_id)\n  }\n    \n  return \"-R '@RG\\\\t\" + param_list.join('\\\\t') + \"'\"\n  \n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "position": 101,
            "separate": true,
            "itemSeparator": "null",
            "valueFrom": {
              "script": "{\n  /////// Set input reads in the correct order depending of the paired end from metadata\n    \n     // Set output file name\n  if($job.inputs.input_reads[0] instanceof Array){\n    input_reads = $job.inputs.input_reads[0] // scatter mode\n  } else {\n    input_reads = $job.inputs.input_reads = [].concat($job.inputs.input_reads)\n  }\n  \n  \n  //Read metadata for input reads\n  read_metadata = input_reads[0].metadata\n  if(!read_metadata) read_metadata = []\n  \n  order = 0 // Consider this as normal order given at input: pe1 pe2\n  \n  // Check if paired end 1 corresponds to the first given read\n  if(read_metadata == []){ order = 0 }\n  else if('paired_end' in  read_metadata){ \n    pe1 = read_metadata.paired_end\n    if(pe1 != 1) order = 1 // change order\n  }\n\n  // Return reads in the correct order\n  if (input_reads.length == 1){\n    return input_reads[0].path // Only one read present\n  }\n  else if (input_reads.length == 2){\n    if (order == 0) return input_reads[0].path + ' ' + input_reads[1].path\n    else return input_reads[1].path + ' ' + input_reads[0].path\n  }\n\n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "position": 2,
            "prefix": "-t",
            "separate": true,
            "itemSeparator": "null",
            "valueFrom": {
              "script": "{\n  MAX_THREADS = 36\n  suggested_threads = 8\n  \n  if($job.inputs.threads){ threads = $job.inputs.threads  }\n  else if ($job.inputs.wgs_hg38_mode_threads){\n    ref_name_arr = $job.inputs.reference_index_tar.path.split('/')\n    ref_name = ref_name_arr[ref_name_arr.length - 1]\n    if (ref_name.search('38') >= 0){threads = $job.inputs.wgs_hg38_mode_threads}\n    else {threads = MAX_THREADS}\n  }\n  else{ threads = suggested_threads  }\n    \n  return threads\n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "position": 10,
            "separate": true,
            "itemSeparator": "null",
            "valueFrom": {
              "script": "{\n  name = ''\n  metadata = [].concat($job.inputs.reference_index_tar)[0].metadata\n  \n  if (metadata && metadata.reference_genome) {\n \tname = metadata.reference_genome\n  }\n  else {\n\treference_file = $job.inputs.reference_index_tar.path.split('/')[$job.inputs.reference_index_tar.path.split('/').length-1]\n  \tname = reference_file.slice(0, -4) // cut .tar extension \n  }\n    \n  return name \t\n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          },
          {
            "position": 10000,
            "separate": true,
            "itemSeparator": "null",
            "valueFrom": {
              "script": "{\n  cmd = \";declare -i pipe_statuses=(\\\\${PIPESTATUS[*]});len=\\\\${#pipe_statuses[@]};declare -i tot=0;echo \\\\${pipe_statuses[*]};for (( i=0; i<\\\\${len}; i++ ));do if [ \\\\${pipe_statuses[\\\\$i]} -ne 0 ];then tot=\\\\${pipe_statuses[\\\\$i]}; fi;done;if [ \\\\$tot -ne 0 ]; then >&2 echo Error in piping. Pipe statuses: \\\\${pipe_statuses[*]};fi; if [ \\\\$tot -ne 0 ]; then false;fi\\\"\"\n  return cmd\n}",
              "engine": "#cwl-js-engine",
              "class": "Expression"
            }
          }
        ],
        "sbg:toolkitVersion": "0.7.17",
        "sbg:image_url": null,
        "sbg:links": [
          {
            "id": "http://bio-bwa.sourceforge.net/",
            "label": "Homepage"
          },
          {
            "id": "https://github.com/lh3/bwa",
            "label": "Source code"
          },
          {
            "id": "http://bio-bwa.sourceforge.net/bwa.shtml",
            "label": "Wiki"
          },
          {
            "id": "http://sourceforge.net/projects/bio-bwa/",
            "label": "Download"
          },
          {
            "id": "http://arxiv.org/abs/1303.3997",
            "label": "Publication"
          },
          {
            "id": "http://www.ncbi.nlm.nih.gov/pubmed/19451168",
            "label": "Publication BWA Algorithm"
          }
        ],
        "sbg:expand_workflow": false,
        "sbg:toolAuthor": "Heng Li",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 4096
          },
          "inputs": {
            "filter_out_secondary_alignments": false,
            "skip_seeds": null,
            "read_group_header": "",
            "reference_index_tar": {
              "size": 0,
              "secondaryFiles": [
                {
                  "path": ".amb"
                },
                {
                  "path": ".ann"
                },
                {
                  "path": ".bwt"
                },
                {
                  "path": ".pac"
                },
                {
                  "path": ".sa"
                }
              ],
              "class": "File",
              "path": "/path/to/reference.HG38.fasta.gz.tar"
            },
            "rg_data_submitting_center": "",
            "rg_median_fragment_length": "",
            "split_alignment_primary": false,
            "deduplication": "RemoveDuplicates",
            "rg_platform_unit_id": "",
            "rg_library_id": "",
            "wgs_hg38_mode_threads": 10,
            "num_input_bases_in_each_batch": null,
            "reserved_threads": null,
            "output_name": "",
            "mark_shorter": false,
            "band_width": null,
            "threads": null,
            "sort_memory": null,
            "output_format": "CRAM",
            "mapQ_of_suplementary": false,
            "rg_sample_id": "",
            "rg_platform": null,
            "input_reads": [
              {
                "size": 30000000000,
                "secondaryFiles": [],
                "metadata": {
                  "platform": "HiSeq X Ten",
                  "sample_id": "dnk_sample",
                  "paired_end": "2"
                },
                "class": "File",
                "path": "/path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_1.gz"
              },
              {
                "path": "/path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_2.gz"
              }
            ],
            "total_memory": null,
            "rg_id": ""
          }
        },
        "sbg:projectName": "SBG Public data",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "Copy of vladimirk/bwa-mem-bundle-0-7-13-demo/bwa-mem-bundle-0-7-13/46"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "init"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "added biobambam2 sort"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "dedup added"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "boolean inputs fixed"
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "output written with >"
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "sambamba and samblaster"
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "samblaster path corrected"
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "Added ALT Contig reference"
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "docs"
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539866,
            "sbg:revisionNotes": "num_bases_reproducibility"
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1532539867,
            "sbg:revisionNotes": "Do_not_use_alt_38 parameter removed due to redundancy"
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711380,
            "sbg:revisionNotes": "Added new @RG options."
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "added bamsormadup"
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "add 'inputformat=sam'"
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "add 'cram output support and capture reference'"
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "capture output with + ' > ' + name + extension"
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "capturing cram output and dups metrics file"
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "add cram selection as an output format"
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "fix output_format options"
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "lower case outputformat=cram"
          },
          {
            "sbg:revision": 21,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "fix typo"
          },
          {
            "sbg:revision": 22,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711381,
            "sbg:revisionNotes": "tar -tv"
          },
          {
            "sbg:revision": 23,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "see tar contents"
          },
          {
            "sbg:revision": 24,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "1>&2"
          },
          {
            "sbg:revision": 25,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "typo"
          },
          {
            "sbg:revision": 26,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "add export REF_CACHE=$CWD"
          },
          {
            "sbg:revision": 27,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "export REF_CACHE=$CWD ;"
          },
          {
            "sbg:revision": 28,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "REF_CACHE=$PWD"
          },
          {
            "sbg:revision": 29,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "set REF_CACHE"
          },
          {
            "sbg:revision": 30,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "link to reference_tarball"
          },
          {
            "sbg:revision": 31,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": ".bam.bai instead only .bai"
          },
          {
            "sbg:revision": 32,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1553711382,
            "sbg:revisionNotes": "_R multi lane"
          },
          {
            "sbg:revision": 33,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1554195132,
            "sbg:revisionNotes": "label version to 0.7.17"
          },
          {
            "sbg:revision": 34,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1556185556,
            "sbg:revisionNotes": "Coordinate Sorted BAM enum label"
          },
          {
            "sbg:revision": 35,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1556185557,
            "sbg:revisionNotes": "description. Threads mapped to bamsortmadup"
          },
          {
            "sbg:revision": 36,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1556185557,
            "sbg:revisionNotes": "-q -5 boolean fix!"
          },
          {
            "sbg:revision": 37,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1558705106,
            "sbg:revisionNotes": "bamsort bamsormadup"
          },
          {
            "sbg:revision": 38,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1558705108,
            "sbg:revisionNotes": "description for deduplication"
          },
          {
            "sbg:revision": 39,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1558705108,
            "sbg:revisionNotes": "bamsort index=1"
          },
          {
            "sbg:revision": 40,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1593179098,
            "sbg:revisionNotes": "biobambam2 off if SAM is output"
          },
          {
            "sbg:revision": 41,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1593179099,
            "sbg:revisionNotes": "Bug fix for CRAM output with no PCR deduplication"
          },
          {
            "sbg:revision": 42,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1593179099,
            "sbg:revisionNotes": "Bug fix for CRAM output with no PCR deduplication"
          },
          {
            "sbg:revision": 43,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1593179099,
            "sbg:revisionNotes": "Coordinate SOrted BAM added to enum list"
          },
          {
            "sbg:revision": 44,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1593179099,
            "sbg:revisionNotes": "Updated JS to assign a unique Read group ID when the tool is scattered"
          }
        ],
        "sbg:license": "BWA: GNU Affero General Public License v3.0, MIT License. Sambamba: GNU GENERAL PUBLIC LICENSE. Samblaster: The MIT License (MIT)",
        "sbg:cmdPreview": "/bin/bash -c \" export REF_CACHE=${PWD} ;  tar -tvf reference.HG38.fasta.gz.tar 1>&2; tar -xf reference.HG38.fasta.gz.tar ;  bwa mem  -R '@RG\\tID:1\\tPL:Illumina\\tSM:dnk_sample' -t 10  reference.HG38.fasta.gz  /path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_2.gz /path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_1.gz  | bamsormadup threads=10 level=1 tmplevel=-1 inputformat=sam outputformat=cram SO=coordinate reference=reference.HG38.fasta.gz indexfilename=LP6005524-DNA_C01_lane_7.sorted.converted.filtered.cram.crai M=LP6005524-DNA_C01_lane_7.sorted.converted.filtered.sormadup_metrics.log > LP6005524-DNA_C01_lane_7.sorted.converted.filtered.cram  ;declare -i pipe_statuses=(\\${PIPESTATUS[*]});len=\\${#pipe_statuses[@]};declare -i tot=0;echo \\${pipe_statuses[*]};for (( i=0; i<\\${len}; i++ ));do if [ \\${pipe_statuses[\\$i]} -ne 0 ];then tot=\\${pipe_statuses[\\$i]}; fi;done;if [ \\$tot -ne 0 ]; then >&2 echo Error in piping. Pipe statuses: \\${pipe_statuses[*]};fi; if [ \\$tot -ne 0 ]; then false;fi\"",
        "sbg:toolkit": "BWA",
        "sbg:categories": [
          "Alignment",
          "FASTQ-Processing"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:id": "admin/sbg-public-data/bwa-mem-bundle-0-7-17/44",
        "sbg:revision": 44,
        "sbg:revisionNotes": "Updated JS to assign a unique Read group ID when the tool is scattered",
        "sbg:modifiedOn": 1593179099,
        "sbg:modifiedBy": "admin",
        "sbg:createdOn": 1532539866,
        "sbg:createdBy": "admin",
        "sbg:project": "admin/sbg-public-data",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "admin"
        ],
        "sbg:latestRevision": 44,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a5d5ba43386cb86187811c307462c95dcb4c8068359061e03c968f630f641325d"
      },
      "label": "BWA MEM Bundle 0.7.17",
      "sbg:x": -184.9499969482422,
      "sbg:y": 158.3000030517578
    },
    {
      "id": "bwa_index_0_7_17",
      "in": [
        {
          "id": "reference",
          "source": "reference"
        }
      ],
      "out": [
        {
          "id": "indexed_reference"
        }
      ],
      "run": {
        "cwlVersion": "sbg:draft-2",
        "class": "CommandLineTool",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "id": "admin/sbg-public-data/bwa-index-0-7-17/1",
        "label": "BWA INDEX",
        "description": "BWA INDEX constructs the FM-index (Full-text index in Minute space) for the reference genome.\nGenerated index files will be used with BWA MEM, BWA ALN, BWA SAMPE and BWA SAMSE tools.\n\nIf input reference file has TAR extension it is assumed that BWA indices came together with it. BWA INDEX will only pass that TAR to the output. If input is not TAR, the creation of BWA indices and its packing in TAR file (together with the reference) will be performed.\n\nTAR also contains alt reference from bwa.kit suggested by the author of the tool for HG38 reference genome.",
        "baseCommand": [
          {
            "class": "Expression",
            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar'){\n    return 'echo Index files passed without any processing!'\n  }\n  else{\n    \n    cp_alt_cmd = ''\n\n    if(!$job.inputs.do_not_add_alt_contig_to_reference){\n      if (reference_file.search('38') >= 0){\n        cp_alt_cmd = 'cp /opt/hs38DH.fa.alt ' + reference_file + '.alt ; '\n      }\n    }\n    \n    index_cmd = 'bwa index '+ reference_file + ' '\n    \n    return cp_alt_cmd + index_cmd\n  }\n}",
            "engine": "#cwl-js-engine"
          }
        ],
        "inputs": [
          {
            "sbg:toolDefaultValue": "auto",
            "sbg:category": "Configuration",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "bwtsw",
                  "is",
                  "div"
                ],
                "name": "bwt_construction"
              }
            ],
            "label": "Bwt construction",
            "description": "Algorithm for constructing BWT index. Available options are:s\tIS linear-time algorithm for constructing suffix array. It requires 5.37N memory where N is the size of the database. IS is moderately fast, but does not work with database larger than 2GB. IS is the default algorithm due to its simplicity. The current codes for IS algorithm are reimplemented by Yuta Mori. bwtsw\tAlgorithm implemented in BWT-SW. This method works with the whole human genome. Warning: `-a bwtsw' does not work for short genomes, while `-a is' and `-a div' do not work not for long genomes.",
            "id": "#bwt_construction"
          },
          {
            "sbg:category": "Configuration",
            "type": [
              "null",
              "string"
            ],
            "label": "Prefix of the index to be output",
            "description": "Prefix of the index [same as fasta name].",
            "id": "#prefix_of_the_index_to_be_output"
          },
          {
            "sbg:toolDefaultValue": "10000000",
            "sbg:category": "Configuration",
            "type": [
              "null",
              "int"
            ],
            "label": "Block size",
            "description": "Block size for the bwtsw algorithm (effective with -a bwtsw).",
            "id": "#block_size"
          },
          {
            "sbg:category": "Configuration",
            "type": [
              "null",
              "boolean"
            ],
            "label": "Output index files renamed by adding 64",
            "description": "Index files named as <in.fasta>64 instead of <in.fasta>.*.",
            "id": "#add_64_to_fasta_name"
          },
          {
            "sbg:stageInput": "link",
            "sbg:category": "File input",
            "type": [
              "File"
            ],
            "label": "Reference",
            "description": "Input reference fasta of TAR file with reference and indices.",
            "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ, TAR",
            "id": "#reference"
          },
          {
            "sbg:category": "Configuration",
            "type": [
              "null",
              "int"
            ],
            "label": "Total memory [Gb]",
            "description": "Total memory [GB] to be reserved for the tool (Default value is 1.5 x size_of_the_reference).",
            "id": "#total_memory"
          },
          {
            "sbg:toolDefaultValue": "False",
            "sbg:stageInput": null,
            "type": [
              "null",
              "boolean"
            ],
            "label": "Do not add alt contigs file to TAR bundle",
            "description": "Do not add alt contigs file to TAR bundle.",
            "id": "#do_not_add_alt_contig_to_reference"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "label": "TARed fasta with its BWA indices",
            "description": "TARed fasta with its BWA indices.",
            "sbg:fileTypes": "TAR",
            "outputBinding": {
              "glob": {
                "class": "Expression",
                "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar'){\n    return reference_file\n  }\n  else{\n    return reference_file + '.tar'\n  }\n}\n",
                "engine": "#cwl-js-engine"
              },
              "sbg:metadata": {
                "reference": {
                  "class": "Expression",
                  "script": "{\n  path = [].concat($job.inputs.reference)[0].path.split('/')\n  last = path.pop()\n  return last\n}",
                  "engine": "#cwl-js-engine"
                }
              },
              "sbg:inheritMetadataFrom": "#reference"
            },
            "id": "#indexed_reference"
          }
        ],
        "requirements": [
          {
            "class": "ExpressionEngineRequirement",
            "id": "#cwl-js-engine",
            "requirements": [
              {
                "class": "DockerRequirement",
                "dockerPull": "rabix/js-engine"
              }
            ]
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": 1
          },
          {
            "class": "sbg:MemRequirement",
            "value": {
              "class": "Expression",
              "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  \n  GB_1 = 1024*1024*1024\n  reads_size = $job.inputs.reference.size\n\n  if(!reads_size) { reads_size = GB_1 }\n  \n  if($job.inputs.total_memory){\n    return $job.inputs.total_memory * 1024\n  } else if (ext=='tar'){\n    return 128\n  }\n    {\n    return (parseInt(1.5 * reads_size / (1024*1024)))\n  }\n}",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "class": "DockerRequirement",
            "dockerImageId": "2f813371e803",
            "dockerPull": "images.sbgenomics.com/vladimirk/bwa:0.7.17"
          }
        ],
        "arguments": [
          {
            "position": 0,
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.bwt_construction){\n    return ''\n  } else {\n    return '-a ' + $job.inputs.bwt_construction\n  }\n}",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "position": 0,
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.prefix){\n    return ''\n  } else {\n    return '-p ' + $job.inputs.prefix\n  }\n}\n",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "position": 0,
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.block_size){\n    return ''\n  } else {\n    return '-b ' + $job.inputs.block_size\n  }\n}\n\n",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "position": 0,
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.add_64_to_fasta_name){\n    return ''\n  } else {\n    return '-6 '\n  }\n}\n",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "position": 0,
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar'){\n    return ''\n  }\n  else{\n    extensions = ' *.amb' + ' *.ann' + ' *.bwt' + ' *.pac' + ' *.sa'\n    if(!$job.inputs.do_not_add_alt_contig_to_reference){\n      if (reference_file.search('38') >= 0){\n        extensions = extensions + ' *.alt ; '\n      }\n    }\n    tar_cmd = 'tar -cf ' + reference_file + '.tar ' + reference_file + extensions\n    return ' ; ' + tar_cmd\n  }\n}",
              "engine": "#cwl-js-engine"
            }
          }
        ],
        "sbg:toolkitVersion": "0.7.17",
        "sbg:image_url": null,
        "sbg:license": "GNU Affero General Public License v3.0, MIT License",
        "sbg:toolAuthor": "Heng Li",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1558353195,
            "sbg:revisionNotes": "Copy of vladimirk/bwa-mem-bundle-0-7-17-demo/bwa-index/3"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1558353196,
            "sbg:revisionNotes": "With alt for hg38."
          }
        ],
        "sbg:links": [
          {
            "id": "http://bio-bwa.sourceforge.net/",
            "label": "Homepage"
          },
          {
            "id": "https://github.com/lh3/bwa",
            "label": "Source code"
          },
          {
            "id": "http://bio-bwa.sourceforge.net/bwa.shtml",
            "label": "Wiki"
          },
          {
            "id": "http://sourceforge.net/projects/bio-bwa/",
            "label": "Download"
          },
          {
            "id": "http://www.ncbi.nlm.nih.gov/pubmed/19451168",
            "label": "Publication"
          }
        ],
        "sbg:toolkit": "BWA",
        "sbg:job": {
          "allocatedResources": {
            "mem": 1536,
            "cpu": 1
          },
          "inputs": {
            "prefix_of_the_index_to_be_output": "prefix",
            "block_size": null,
            "reference": {
              "class": "File",
              "secondaryFiles": [
                {
                  "path": ".amb"
                },
                {
                  "path": ".ann"
                },
                {
                  "path": ".bwt"
                },
                {
                  "path": ".pac"
                },
                {
                  "path": ".sa"
                }
              ],
              "path": "/path/to/the/reference38.fasta",
              "size": 0
            },
            "bwt_construction": null,
            "add_64_to_fasta_name": false,
            "do_not_add_alt_contig_to_reference": false,
            "total_memory": null
          }
        },
        "sbg:projectName": "SBG Public data",
        "sbg:cmdPreview": "cp /opt/hs38DH.fa.alt reference38.fasta.alt ; bwa index reference38.fasta            ; tar -cf reference38.fasta.tar reference38.fasta *.amb *.ann *.bwt *.pac *.sa *.alt ;",
        "sbg:categories": [
          "Indexing",
          "FASTA-Processing"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:id": "admin/sbg-public-data/bwa-index-0-7-17/1",
        "sbg:revision": 1,
        "sbg:revisionNotes": "With alt for hg38.",
        "sbg:modifiedOn": 1558353196,
        "sbg:modifiedBy": "admin",
        "sbg:createdOn": 1558353195,
        "sbg:createdBy": "admin",
        "sbg:project": "admin/sbg-public-data",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "admin"
        ],
        "sbg:latestRevision": 1,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a84d15b8b6b6434fdbafadfb705b8897d9e8e2096182cbb3cc36f103c6141d4cc"
      },
      "label": "BWA INDEX",
      "sbg:x": -337.34832763671875,
      "sbg:y": 59.044944763183594
    },
    {
      "id": "variant_effect_predictor_101_0_cwl1_0",
      "in": [
        {
          "id": "in_variants",
          "source": "gatk_4_0_haplotypecaller/output_vcf"
        },
        {
          "id": "cache_file",
          "source": "cache_file"
        },
        {
          "id": "variant_class",
          "source": "variant_class"
        },
        {
          "id": "pick",
          "source": "pick"
        },
        {
          "id": "species",
          "source": "species"
        }
      ],
      "out": [
        {
          "id": "vep_output_file"
        },
        {
          "id": "compressed_vep_output"
        },
        {
          "id": "summary_file"
        },
        {
          "id": "warning_file"
        }
      ],
      "run": {
        "class": "CommandLineTool",
        "cwlVersion": "v1.0",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "id": "admin/sbg-public-data/variant-effect-predictor-101-0-cwl1-0/6",
        "baseCommand": [],
        "inputs": [
          {
            "sbg:category": "Input options",
            "id": "in_variants",
            "type": "File",
            "inputBinding": {
              "prefix": "--input_file",
              "shellQuote": false,
              "position": 0
            },
            "label": "Input VCF",
            "doc": "Input VCF file to annotate.",
            "sbg:fileTypes": "VCF, VCF.GZ"
          },
          {
            "sbg:category": "Cache options",
            "id": "cache_file",
            "type": "File",
            "label": "Species cache file",
            "doc": "Cache file for the chosen species.",
            "sbg:fileTypes": "TAR.GZ"
          },
          {
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "8",
            "id": "cpu_per_job",
            "type": "int?",
            "label": "Number of CPUs",
            "doc": "Number of CPUs to use."
          },
          {
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "15000",
            "id": "mem_per_job",
            "type": "int?",
            "label": "Memory to use for the task",
            "doc": "Assign memory for the execution in MB."
          },
          {
            "sbg:category": "Input options",
            "sbg:toolDefaultValue": "Use found assembly version",
            "id": "assembly",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "GRCh37",
                  "GRCh38"
                ],
                "name": "assembly"
              }
            ],
            "inputBinding": {
              "prefix": "--assembly",
              "shellQuote": false,
              "position": 0
            },
            "label": "Assembly version",
            "doc": "Select the assembly version to use if more than one available. If using the cache, you must have the appropriate assembly's cache file installed. If not specified and you have only 1 assembly version installed, this will be chosen by default. For homo sapiens use either GRCh38 or GRCh37."
          },
          {
            "sbg:category": "Cache options",
            "id": "in_references",
            "type": "File[]?",
            "inputBinding": {
              "prefix": "--fasta",
              "shellQuote": false,
              "position": 0
            },
            "label": "Fasta file(s) to use to look up reference sequence",
            "doc": "Specify a FASTA file or a directory containing FASTA files to use to look up reference sequence. The first time you run the script with this parameter an index will be built which can take a few minutes. This is required if fetching HGVS annotations (--hgvs) or checking reference sequences (--check_ref) in offline mode (--offline), and optional with some performance increase in cache mode (--cache).",
            "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ"
          },
          {
            "sbg:category": "Basic options",
            "sbg:toolDefaultValue": "8",
            "id": "fork",
            "type": "int?",
            "inputBinding": {
              "prefix": "--fork",
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n  if (inputs.fork!=-1)\n  {\n    return inputs.fork;\n  }\n  else if (inputs.cpu_per_job)\n  {\n    return inputs.cpu_per_job;\n  }\n  else\n  {\n    return 8;\n  }\n}\n    "
            },
            "label": "Fork number",
            "doc": "Enable forking, using the specified number of forks. Forking can dramatically improve the runtime of the script. Not used by default.",
            "default": -1
          },
          {
            "sbg:category": "Cache options",
            "sbg:toolDefaultValue": "20000",
            "id": "buffer_size",
            "type": "int?",
            "inputBinding": {
              "prefix": "--buffer_size",
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n  if (inputs.buffer_size!=-1 && inputs.buffer_size>1000)\n  \treturn inputs.buffer_size;\n  else\n    return 20000;\n}"
            },
            "label": "Buffer size to use",
            "doc": "Sets the internal buffer size, corresponding to the number of variations that are read in to memory simultaneously. Set this lower to use less memory at the expense of longer run time, and higher to use more memory with a faster run time. Default = 5000.",
            "default": -1
          },
          {
            "sbg:category": "Plugins",
            "id": "dbNSFP_file",
            "type": "File?",
            "inputBinding": {
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n if (inputs.dbNSFP_file && inputs.dbNSFP_columns!=undefined)\n {\n   var tempout=\"--plugin dbNSFP,\".concat(inputs.dbNSFP_file.path).concat(\",\").concat(inputs.dbNSFP_columns.join());\n   return tempout;\n }\n else if (inputs.dbNSFP_file)\n {\n   var tempout=\"--plugin dbNSFP,\".concat(inputs.dbNSFP_file.path, ',FATHMM_pred,MetaSVM_pred,GERP++_RS');\n   return tempout;\n }\n else\n {\n   return '';\n }\n}"
            },
            "label": "dbNSFP database file",
            "doc": "dbNSFP database file used by the dbNSFP plugin. Please note that dbNSFP 3.x versions should be used for GRCh38, whereas 2.x versions correspond to GRCh37.",
            "sbg:fileTypes": "GZ",
            "secondaryFiles": [
              ".tbi"
            ]
          },
          {
            "sbg:category": "Plugins",
            "sbg:toolDefaultValue": "FATHMM_pred,MetaSVM_pred,GERP++_RS",
            "id": "dbNSFP_columns",
            "type": "string[]?",
            "label": "Columns of dbNSFP to report",
            "doc": "Columns of dbNSFP database to be included in the VCF. Please see dbNSFP readme files for a full list."
          },
          {
            "sbg:category": "Plugins",
            "id": "dbscSNV_f",
            "type": "File?",
            "inputBinding": {
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n if (inputs.dbscSNV_f)\n {\n   var tempout=\"--plugin dbscSNV,\".concat(inputs.dbscSNV_f.path);\n   return tempout;\n }\n else\n {\n   return \"\";\n }\n}\n\n"
            },
            "label": "dbscSNV database file",
            "doc": "Preprocessed database file for the dbscSNV plugin.",
            "sbg:fileTypes": "GZ",
            "secondaryFiles": [
              ".tbi"
            ]
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "gff_annotation_file",
            "type": "File?",
            "inputBinding": {
              "prefix": "--gff",
              "shellQuote": false,
              "position": 0
            },
            "label": "GFF annotation file",
            "doc": "Use GFF transcript annotations as an annotation source. Requires a FASTA file of genomic sequence.",
            "sbg:fileTypes": "GFF.GZ",
            "secondaryFiles": [
              ".tbi"
            ]
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "gtf_annotation_file",
            "type": "File?",
            "inputBinding": {
              "prefix": "--gtf",
              "shellQuote": false,
              "position": 0
            },
            "label": "GTF annotation file",
            "doc": "Use GTF transcript annotations as an annotation source. Requires a FASTA file of genomic sequence.",
            "sbg:fileTypes": "GTF.GZ",
            "secondaryFiles": [
              ".tbi"
            ]
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "bam_transcript_models_corrections_file",
            "type": "File?",
            "inputBinding": {
              "prefix": "--bam",
              "shellQuote": false,
              "position": 0
            },
            "label": "NCBI BAM file for correcting transcript models",
            "doc": "Use BAM file of sequence alignments to correct transcript models not derived from reference genome sequence. Used to correct RefSeq transcript models. Enables --use_transcript_ref; add --use_given_ref to override this behaviour. Eligible BAM inputs are available from NCBI (see VEP documentation).",
            "sbg:fileTypes": "BAM",
            "secondaryFiles": [
              ".bai"
            ]
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "custom_annotation_sources",
            "type": "File[]?",
            "inputBinding": {
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n  if (inputs.custom_annotation_sources != undefined)\n  {\n    var tempout = '';\n    for (var k = 0, len=inputs.custom_annotation_sources.length; k < len; k++)\n    {\n      if (inputs.custom_annotation_sources[k].path != '')\n      {\n        tempout = tempout.concat(' --custom ', inputs.custom_annotation_sources[k].path);\n        if ((inputs.custom_annotation_parameters[k] != 'None') && (inputs.custom_annotation_parameters[k] != undefined))\n        {\n          tempout = tempout.concat(',',inputs.custom_annotation_parameters[k]);\n        }\n      }\n    }\n  return tempout;\n  }\n}"
            },
            "label": "Custom annotation sources",
            "doc": "Add custom annotation to the output. Files must be tabix indexed or in the bigWig format. Multiple files can be specified. See VEP documentation for full details.",
            "secondaryFiles": [
              ".tbi"
            ]
          },
          {
            "sbg:category": "Basic options",
            "id": "config_file",
            "type": "File?",
            "inputBinding": {
              "prefix": "--config",
              "shellQuote": false,
              "position": 0
            },
            "label": "Optional config file",
            "doc": "Load configuration options from a config file. The config file should consist of whitespace-separated pairs of option names and settings. Options from this file will be overwritten by options manually supplied on the command line."
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "custom_annotation_parameters",
            "type": "string[]?",
            "label": "Annotation parameters for custom annotation sources (comma separated values, ensembl-vep --custom flag format)",
            "doc": "Annotation parameters for custom annotation sources, one field for each custom annotation source supplied, in the same order. If no parameters should be applied to an annotation source, please type None. Entries should follow the ensembl-vep --custom flag format."
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "custom_annotation_BigWig_sources",
            "type": "File[]?",
            "inputBinding": {
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n  if (inputs.custom_annotation_BigWig_sources != undefined)\n  {\n    var tempout = '';\n    for (var k = 0, len=inputs.custom_annotation_BigWig_sources.length; k < len; k++)\n    {\n      if (inputs.custom_annotation_BigWig_sources[k].path != '')\n      {\n        tempout = tempout.concat(' --custom ', inputs.custom_annotation_BigWig_sources[k].path);\n        if ((inputs.custom_annotation_BigWig_parameters[k] != 'None') && (inputs.custom_annotation_BigWig_parameters[k] != undefined))\n        {\n          tempout = tempout.concat(',',inputs.custom_annotation_BigWig_parameters[k]);\n        }\n      }\n    }\n  return tempout;\n  }\n}"
            },
            "label": "Custom annotation - BigWig sources only",
            "doc": "Custon annotation sources - please list your BigWig annotation sources only here.",
            "sbg:fileTypes": "BW"
          },
          {
            "sbg:category": "Other annotation sources",
            "id": "custom_annotation_BigWig_parameters",
            "type": "string[]?",
            "label": "Annotation parameters for custom BigWig annotation sources only",
            "doc": "Annotation parameters for custom BigWig annotation sources. One entry per source, in order of files supplied, in ensembl-vep --custom flag format."
          },
          {
            "sbg:category": "Input options",
            "sbg:toolDefaultValue": "STDERR",
            "id": "warning_file_name",
            "type": "string?",
            "inputBinding": {
              "prefix": "--warning_file",
              "shellQuote": false,
              "position": 0,
              "valueFrom": "${\n  if (inputs.warning_file_name)\n  {\n    return inputs.warning_file_name.concat('_vep_warnings.txt');\n  }\n}"
            },
            "label": "Optional file name for warnings file output",
            "doc": "File name to write warnings and errors to."
          },
          {
            "sbg:category": "Output options",
            "id": "individuals_to_annotate",
            "type": "string[]?",
            "inputBinding": {
              "prefix": "--individual",
              "itemSeparator": ",",
              "shellQuote": false,
              "position": 1,
              "valueFrom": "${\n  if (inputs.individuals_to_annotate)\n  {\n    return inputs.individuals_to_annotate;\n  }\n}"
            },
            "label": "Samples to annotate [--individual]",
            "doc": "Consider only alternate alleles present in the genotypes of the specified individual(s). May be a single individual, a list of samples or \"all\" to assess all individuals separately. Individual variant combinations homozygous for the given reference allele will not be reported. Each individual and variant combination is given on a separate line of output. Only works with VCF files containing individual genotype data; individual IDs are taken from column headers. Not used by default."
          },
          {
            "sbg:category": "Basic options",
            "sbg:toolDefaultValue": "False",
            "id": "everything",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--everything",
              "shellQuote": false,
              "position": 1
            },
            "label": "Shortcut flag to turn on most commonly used annotations [--everything]",
            "doc": "Shortcut flag to switch on all of the following: --sift b, --polyphen b, --ccds, --uniprot, --hgvs, --symbol, --numbers, --domains, --regulatory, --canonical, --protein, --biotype, --uniprot, --tsl, --appris, --gene_phenotype --af, --af_1kg, --af_esp, --af_gnomad, --max_af, --pubmed, --variant_class, --mane."
          },
          {
            "sbg:category": "Cache options",
            "sbg:toolDefaultValue": "101",
            "id": "cache_version",
            "type": "int?",
            "inputBinding": {
              "prefix": "--cache_version",
              "shellQuote": false,
              "position": 2
            },
            "label": "Version of VEP cache if not default",
            "doc": "Use a different cache version than the assumed default (the VEP version). This should be used with Ensembl Genomes caches since their version numbers do not match Ensembl versions. For example, the VEP/Ensembl version may be 74 and the Ensembl Genomes version 21. Not used by default."
          },
          {
            "sbg:category": "Cache options",
            "sbg:toolDefaultValue": "Ensembl cache",
            "id": "cache_type",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "Ensembl cache",
                  "RefSeq cache",
                  "Merged cache"
                ],
                "name": "cache_type"
              }
            ],
            "inputBinding": {
              "shellQuote": false,
              "position": 2,
              "valueFrom": "${\n  if (inputs.cache_type)\n  {\n    if (inputs.cache_type=='RefSeq cache')\n    {\n      return '--refseq';\n    }\n    else if (inputs.cache_type=='Merged cache')\n    {\n      return '--merged';\n    }\n    else\n    {\n      return '';\n    }\n  }\n  else\n  {\n    return '';\n  }\n}"
            },
            "label": "Specify whether the cache used is an Ensembl, RefSeq or merged VEP cache",
            "doc": "Specify whether the cache used is an Ensembl, RefSeq or merged VEP cache (--refseq or --merged). Ensembl is the default and does not have to be specified as such.  Specify this option if you have installed the RefSeq cache in order for VEP to pick up the alternate cache directory. This cache contains transcript objects corresponding to RefSeq transcripts (to include CCDS and Ensembl ESTs also, use --all_refseq). Consequence output will be given relative to these transcripts in place of the default Ensembl transcripts.  Use the merged Ensembl and RefSeq cache. Consequences are flagged with the SOURCE of each transcript used."
          },
          {
            "sbg:category": "Input options",
            "sbg:toolDefaultValue": "False",
            "id": "no_stats",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--no_stats",
              "shellQuote": false,
              "position": 2
            },
            "label": "Do not generate a stats file [--no_stats]",
            "doc": "Don't generate a stats file. Provides marginal gains in run time."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "variant_class",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--variant_class",
              "shellQuote": false,
              "position": 3
            },
            "label": "Output Sequence Ontology variant class",
            "doc": "Output the Sequence Ontology variant class. Not used by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "humdiv",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--humdiv",
              "shellQuote": false,
              "position": 4
            },
            "label": "PolyPhen2 HumDiv",
            "doc": "Retrieve the humDiv PolyPhen prediction instead of the defaulat humVar. Not used by default.HumDiv-trained model should be used for evaluating rare alleles at loci potentially involved in complex phenotypes, dense mapping of regions identified by genome-wide association studies, and analysis of natural selection from sequence data, where even mildly deleterious alleles must be treated as damaging. Human only."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "sift",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "prediction",
                  "score",
                  "both (prediction and score)"
                ],
                "name": "sift"
              }
            ],
            "inputBinding": {
              "shellQuote": false,
              "position": 4,
              "valueFrom": "${\n  if (inputs.sift)\n  {\n    if (inputs.sift == 'prediction')\n    {\n      return '--sift p';\n    }\n    else if (inputs.sift == 'score')\n    {\n      return '--sift s';\n    }\n    else if (inputs.sift == 'both (prediction and score)')\n    {\n      return '--sift b';\n    }\n  }\n}"
            },
            "label": "SIFT prediction",
            "doc": "SIFT predicts whether an amino acid substitution affects protein function based on sequence homology and the physical properties of amino acids. VEP can output the prediction term, score or both. Not used by default"
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "Not used by default.",
            "id": "polyphen",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "prediction",
                  "score",
                  "both (prediction and score)"
                ],
                "name": "polyphen"
              }
            ],
            "inputBinding": {
              "shellQuote": false,
              "position": 4,
              "valueFrom": "${\n  if (inputs.polyphen)\n  {\n    if (inputs.polyphen == 'prediction')\n    {\n      return '--polyphen p';\n    }\n    else if (inputs.polyphen == 'score')\n    {\n      return '--polyphen s';\n    }\n    else if (inputs.polyphen == 'both (prediction and score)')\n    {\n      return '--polyphen b';\n    }\n  }\n}"
            },
            "label": "PolyPhen prediction",
            "doc": "PolyPhen is a tool which predicts possible impact of an amino acid substitution on the structure and function of a human protein using straightforward physical and comparative considerations. VEP can output the prediction term, score or both. VEP uses the humVar score by default - please set the additional humDiv option to retrieve the humDiv score. Not used by default. Human only."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "domains",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--domains",
              "shellQuote": false,
              "position": 5
            },
            "label": "Overlapping protein domains",
            "doc": "Adds names of overlapping protein domains to output."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "no_escape",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--no_escape",
              "shellQuote": false,
              "position": 5
            },
            "label": "No url escaping HGSV strings",
            "doc": "Don't URI escape HGVS strings."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "5000",
            "id": "distance",
            "type": "string?",
            "inputBinding": {
              "prefix": "--distance",
              "shellQuote": false,
              "position": 5
            },
            "label": "Distance",
            "doc": "Modify the distance up and/or downstream between a variant and a transcript for which VEP will assign the upstream_gene_variant or downstream_gene_variant consequences. Giving one distance will modify both up- and downstream distances; prodiving two separated by commas will set the up- (5') and down- (3') stream distances respectively. Default: 5000"
          },
          {
            "sbg:category": "Output options",
            "id": "gene_phenotype",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--gene_phenotype",
              "shellQuote": false,
              "position": 5
            },
            "label": "Connect overlapped gene with phenotype",
            "doc": "Indicates if the overlapped gene is associated with a phenotype, disease or trait. Not used by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "keep_csq",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--keep_csq",
              "shellQuote": false,
              "position": 5
            },
            "label": "Keep existing CSQ entries in the input VCF INFO field",
            "doc": "Don't overwrite existing CSQ entry in VCF INFO field. Overwrites by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "Sequence Ontology",
            "id": "terms",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "Sequence Ontology",
                  "Ensembl"
                ],
                "name": "terms"
              }
            ],
            "inputBinding": {
              "prefix": "--terms",
              "shellQuote": false,
              "position": 5,
              "valueFrom": "${\n  if (inputs.terms)\n  {\n    if (inputs.terms == 'Sequence Ontology')\n    {\n      return 'SO';\n    }\n    else if (inputs.terms == 'Ensembl')\n    {\n      return 'ensembl';\n    }\n  }\n}"
            },
            "label": "Type of consequence terms to report",
            "doc": "Type of consequence terms to output (Ensembl or Sequence Ontology) Default = Sequence Ontology."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "numbers",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--numbers",
              "shellQuote": false,
              "position": 5
            },
            "label": "Adds affected exon and intron numbering",
            "doc": "Adds affected exon and intron numbering to to output. Format is Number/Total. Not used by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "total_length",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--total_length",
              "shellQuote": false,
              "position": 5
            },
            "label": "Add cDNA, CDS and protein positions (position/length)",
            "doc": "Give cDNA, CDS and protein positions as Position/Length. Not used by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "CSQ",
            "id": "vcf_info_field",
            "type": "string?",
            "inputBinding": {
              "prefix": "--vcf_info_field",
              "shellQuote": false,
              "position": 5
            },
            "label": "VCF info field name",
            "doc": "Change the name of the INFO key that VEP write the consequences to in its VCF output. Use \"ANN\" for compatibility with other tools such as snpEff. Default: CSQ."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "nearest",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "transcript",
                  "gene",
                  "symbol"
                ],
                "name": "nearest"
              }
            ],
            "inputBinding": {
              "prefix": "--nearest",
              "shellQuote": false,
              "position": 5,
              "valueFrom": "${\n  if (inputs.nearest)\n  {\n    return inputs.nearest;\n  }\n}"
            },
            "label": "Retrieve nearest transcript/gene",
            "doc": "Retrieve the transcript or gene with the nearest protein-coding transcription start site (TSS) to each input variant. Use \"transcript\" to retrieve the transcript stable ID, \"gene\" to retrieve the gene stable ID, or \"symbol\" to retrieve the gene symbol. Note that the nearest TSS may not belong to a transcript that overlaps the input variant, and more than one may be reported in the case where two are equidistant from the input coordinates."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "allele_number",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--allele_number",
              "shellQuote": false,
              "position": 5
            },
            "label": "Identify allele number from VCF input",
            "doc": "Identify allele number from VCF input, where 1 = first ALT allele, 2 = second ALT allele etc. Useful when using --minimal. Not used by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "no_headers",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--no_headers",
              "shellQuote": false,
              "position": 5
            },
            "label": "Do not write header lines to output files",
            "doc": "Do not write header lines in output files."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "regulatory",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--regulatory",
              "shellQuote": false,
              "position": 6
            },
            "label": "Report overlaps with regulatory regions [--regulatory]",
            "doc": "Look for overlaps with regulatory regions. The script can also call if a variant falls in a high information position within a transcription factor binding site. Output lines have a Feature type of RegulatoryFeature or MotifFeature. Not used by default."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "cell_type",
            "type": "string[]?",
            "inputBinding": {
              "prefix": "--cell_type",
              "itemSeparator": ",",
              "shellQuote": false,
              "position": 6,
              "valueFrom": "${\n  if (inputs.cell_type)\n  {\n    return inputs.cell_type;\n  }\n}"
            },
            "label": "Cell type(s) to report regulatory regions for",
            "doc": "Report only regulatory regions that are found in the given cell type(s). Can be a single cell type or a comma-separated list. The functional type in each cell type is reported under CELL_TYPE in the output."
          },
          {
            "sbg:category": "Identifiers",
            "id": "synonyms",
            "type": "File?",
            "inputBinding": {
              "prefix": "--synonyms",
              "shellQuote": false,
              "position": 8
            },
            "label": "Chromosome synonyms",
            "doc": "Load a file of chromosome synonyms. File should be tab-delimited with the primary identifier in column 1 and the synonym in column 2. Synonyms are used bi-directionally so columns may be switched. Synoyms allow you to use different chromosome identifiers in your input file to those used in any annotation source used (cache, DB).",
            "sbg:fileTypes": "TSV, TXT"
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "appris",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--appris",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add APPRIS identifiers",
            "doc": "Adds the APPRIS isoform annotation for this transcript to the output. Not available for GRCh37. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "xref_refseq",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--xref_refseq",
              "shellQuote": false,
              "position": 8
            },
            "label": "Output aligned RefSeq mRNA identifier",
            "doc": "Output aligned RefSeq mRNA identifier for transcript. NB: theRefSeq and Ensembl transcripts aligned in this way MAY NOT, AND FREQUENTLY WILL NOT, match exactly in sequence, exon structure and protein product."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "hgvs",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--hgvs",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add HGVS identifiers",
            "doc": "Add HGVS nomenclature based on Ensembl stable identifiers to the output. Both coding and protein sequence names are added where appropriate. A FASTA file is required to generate HGVS identifiers on SBPLA. HGVS notations given on Ensembl identifiers are versioned. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "hgvsg",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--hgvsg",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add genomic HGVS identifiers",
            "doc": "Add genomic HGVS nomenclature based on the input chromosome name. FASTA file is required. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "protein",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--protein",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add Ensembl protein identifiers",
            "doc": "Add Ensembl protein identifiers to the output where appropriate. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "symbol",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--symbol",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add gene symbols where available",
            "doc": "Adds the gene symbol (e.g. HGNC) (where available) to the output. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "ccds",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--ccds",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add CCDS transcript identifers",
            "doc": "Add CCDS transcript identifers (where available) to the output. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "uniprot",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--uniprot",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add UniProt-associated database identifiers",
            "doc": "Adds best match accessions for translated protein products from three UniProt-related databases (SWISSPROT, TREMBL and UniParc) to the output. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "tsl",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--tsl",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add transcript support level",
            "doc": "Add transcript support level for this transcript to the output. Note: not available for GRCh37.Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "canonical",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--canonical",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add a flag indicating if the transcript is canonical",
            "doc": "Adds a flag indicating if the transcript is the canonical transcript for the gene. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "biotype",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--biotype",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add biotype of transcript or regulatory feature",
            "doc": "Adds the biotype of the transcript or regulatory feature. Not used by default."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "Shift (1)",
            "id": "shift_hgvs",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "Do not shift (0)",
                  "Shift (1)"
                ],
                "name": "shift_hgvs"
              }
            ],
            "inputBinding": {
              "shellQuote": false,
              "position": 8,
              "valueFrom": "${\n  if (inputs.shift_hgvs == 'Do not shift (0)')\n  {\n    return \"--shift_hgvs 0\";\n  }\n  else if (inputs.shift_hgvs == 'Shift (1)')\n  {\n    return \"--shift_hgvs 1\";\n  }\n}"
            },
            "label": "Enable or disable 3' shifting of HGVS notations",
            "doc": "Enable or disable 3' shifting of HGVS notations. When enabled, this causes ambiguous insertions or deletions (typically in repetetive sequence tracts) to be \"shifted\" to their most 3' possible coordinates (relative to the transcript sequence and strand) before the HGVS notations are calculated; the flag HGVS_OFFSET is set to the number of bases by which the variant has shifted, relative to the input genomic coordinates. Disabling retains the original input coordinates of the variant. Default: 1 (shift)."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "Exclude failed variants [0]",
            "id": "failed",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "Exclude failed variants [0]",
                  "Include failed variants [1]"
                ],
                "name": "failed"
              }
            ],
            "inputBinding": {
              "prefix": "--failed",
              "shellQuote": false,
              "position": 10,
              "valueFrom": "${\n  if (inputs.failed)\n  {\n    if (inputs.failed == 'Include failed variants [1]')\n    {\n      return '1';\n    }\n    else if (inputs.failed == 'Exclude failed variants [0]')\n    {\n      return '0';\n    }\n  }\n}"
            },
            "label": "Include failed collocated variants",
            "doc": "When checking for co-located variants, by default the script will exclude variants that have been flagged as failed. Set this flag to include such variants. Default: 0 (exclude)."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "check_existing",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--check_existing",
              "shellQuote": false,
              "position": 10
            },
            "label": "Check for co-located known variants",
            "doc": "Check for the existence of known variants that are co-located with your input. By default the alleles are compared and variants on an allele-specific basis - to compare only coordinates, use --no_check_alleles option.  Some databases may contain variants with unknown (null) alleles and these are included by default; to exclude them use --exclude_null_alleles."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "pubmed",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--pubmed",
              "shellQuote": false,
              "position": 10
            },
            "label": "Report Pubmed IDs for publications that cite an existing variant",
            "doc": "Report Pubmed IDs for publications that cite existing variant. Must be used with a vep cache. Not used by default."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "af",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--af",
              "shellQuote": false,
              "position": 10
            },
            "label": "Add 1000 genomes phase 3 global allele frequency",
            "doc": "Add the global allele frequency (AF) from 1000 Genomes Phase 3 data for any known co-located variant to the output. For this and all --af_* flags, the frequency reported is for the input allele only, not necessarily the non-reference or derived allele. Supercedes --gmaf.Not used by default."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "af_1kg",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--af_1kg",
              "shellQuote": false,
              "position": 10
            },
            "label": "Add allele frequency from continental 1000 genomes populations",
            "doc": "Add allele frequency from continental populations (AFR,AMR,EAS,EUR,SAS) of 1000 Genomes Phase 3 to the output. Must be used with --cache. Supercedes --maf_1kg. Not used by default."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "af_esp",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--af_esp",
              "shellQuote": false,
              "position": 10
            },
            "label": "Add allele frequency from NHLBI-ESP populations",
            "doc": "Include allele frequency from NHLBI-ESP populations. Must be used with --cache. Supercedes --maf_esp. Not used by default."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "af_gnomad",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "",
              "shellQuote": false,
              "position": 10,
              "valueFrom": "${\n  if ((inputs.cache_version) && (inputs.cache_version < 90) && (inputs.af_gnomad))\n  {\n    return '--af_exac';\n  }\n  else if (inputs.af_gnomad)\n  {\n    return '--af_gnomad';\n  }\n}"
            },
            "label": "Add gnomAD allele frequencies (or ExAc frequencies with cache < 90)",
            "doc": "Include allele frequency from Genome Aggregation Database (gnomAD) exome populations. Note only data from the gnomAD exomes are included; to retrieve data from the additional genomes data set, please see ensembl-vep documentation. Must be used with --cache Not used by default. If a vep cache version < 90 is used, the ExAc frequencies are reported instead."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "exclude_null_alleles",
            "type": "boolean?",
            "inputBinding": {
              "shellQuote": false,
              "position": 10,
              "valueFrom": "${\n  if (inputs.check_existing)\n  {\n    if (inputs.exclude_null_alleles)\n    {\n      return '--exclude_null_alleles';\n    }\n  }\n  else\n  {\n    return '';\n  }\n}\n    "
            },
            "label": "Exclude null alleles when checking co-located variants",
            "doc": "Do not include variants with unknown alleles when checking for co-located variants. The human variation database contains variants from HGMD and COSMIC for which the alleles are not publically available; by default these are included when using --check_existing, use this flag to exclude them. Not used by default."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "no_check_alleles",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--no_check_alleles",
              "shellQuote": false,
              "position": 10
            },
            "label": "Do not check alleles of co-located variants",
            "doc": "When checking for existing variants, by default VEP only reports a co-located variant if none of the input alleles are novel. For example, if the user input has alleles A/G, and an existing co-located variant has alleles A/C, the co-located variant will not be reported.  Strand is also taken into account - in the same example, if the user input has alleles T/G but on the negative strand, then the co-located variant will be reported since its alleles match the reverse complement of user input.  Use this flag to disable this behaviour and compare using coordinates alone. Not used by default."
          },
          {
            "sbg:category": "Co-located variants",
            "sbg:toolDefaultValue": "False",
            "id": "max_af",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--max_af",
              "shellQuote": false,
              "position": 10
            },
            "label": "Report highest allele frequency observed in 1000 genomes, ESP or gnomAD populations",
            "doc": "Report the highest allele frequency observed in any population from 1000 genomes, ESP or gnomAD. Not used by default."
          },
          {
            "sbg:category": "Data format options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "compress_output",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "gzip",
                  "bgzip"
                ],
                "name": "compress_output"
              }
            ],
            "inputBinding": {
              "prefix": "--compress_output",
              "shellQuote": false,
              "position": 11
            },
            "label": "Compress output",
            "doc": "Writes output compressed using either gzip or bgzip. Not used by default"
          },
          {
            "sbg:category": "Data format options",
            "sbg:toolDefaultValue": "vcf",
            "id": "output_format",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "vcf",
                  "tab",
                  "json"
                ],
                "name": "output_format"
              }
            ],
            "inputBinding": {
              "shellQuote": false,
              "position": 11,
              "valueFrom": "${\n  if (inputs.output_format!='vcf')\n  {\n    if (inputs.output_format == 'tab')\n    {\n      return '--tab';\n    }\n    else if (inputs.output_format == 'json')\n    {\n      return '--json';\n    }\n  }\n  else if (inputs.output_format=='vcf')\n  {\n    return '--vcf';\n  }\n  else if (!inputs.most_severe)\n  {\n    return '--vcf';\n  }\n}"
            },
            "label": "Output format",
            "doc": "Format in which to write the output. VCF by default.",
            "default": "vcf"
          },
          {
            "sbg:category": "Data format options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "fields",
            "type": "string[]?",
            "inputBinding": {
              "prefix": "--fields",
              "itemSeparator": ",",
              "shellQuote": false,
              "position": 11
            },
            "label": "Fields to configure the output format (VCF or tab only) with",
            "doc": "Configure the output format using a list of fields. Fields may be those present in the default output columns, or any of those that appear in the Extra column (including those added by plugins or custom annotations). Output remains tab-delimited. Can only be used with tab or VCF format output. Not used by default."
          },
          {
            "sbg:category": "Data format options",
            "sbg:toolDefaultValue": "False",
            "id": "minimal",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--minimal",
              "shellQuote": false,
              "position": 11
            },
            "label": "Convert alleles to minimal representation before assigning consequences",
            "doc": "Convert alleles to their most minimal representation before consequence calculation i.e. sequence that is identical between each pair of reference and alternate alleles is trimmed off from both ends, with coordinates adjusted accordingly. Note this may lead to discrepancies between input coordinates and coordinates reported by VEP relative to transcript sequences; to avoid issues, use --allele_number and/or ensure that your input variants have unique identifiers. The MINIMISED flag is set in the VEP output where relevant. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "dont_skip",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--dont_skip",
              "shellQuote": false,
              "position": 15
            },
            "label": "Do not skip input variants that fail validation",
            "doc": "Don't skip input variants that fail validation, e.g. those that fall on unrecognised sequences."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "allow_non_variant",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--allow_non_variant",
              "shellQuote": false,
              "position": 15
            },
            "label": "Keep non-variant lines (null ALT) in the VEP VCF output",
            "doc": "When using VCF format as input and output, by default VEP will skip non-variant lines of input (where the ALT allele is null). Enabling this option the lines will be printed in the VCF output with no consequence data added."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "check_ref",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--check_ref",
              "shellQuote": false,
              "position": 15
            },
            "label": "Check REF allele against provided reference sequence",
            "doc": "Force the script to check the supplied reference allele against the sequence stored in the Ensembl Core database or supplied FASTA file. Lines that do not match are skipped. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "gencode_basic",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--gencode_basic",
              "shellQuote": false,
              "position": 15
            },
            "label": "Limit analysis to GENCODE basic transcript set",
            "doc": "Limit your analysis to transcripts belonging to the GENCODE basic set. This set has fragmented or problematic transcripts removed. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "all_refseq",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--all_refseq",
              "shellQuote": false,
              "position": 15
            },
            "label": "Include Ensembl identifiers when using RefSeq and merged caches",
            "doc": "When using the RefSeq or merged cache, include e.g. CCDS and Ensembl EST transcripts in addition to those from RefSeq (see documentation). Only works when using --refseq or --merged."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "exclude_predicted",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--exclude_predicted",
              "shellQuote": false,
              "position": 15
            },
            "label": "Exclude predicted transcripts when using RefSeq or merged cache",
            "doc": "When using RefSeq or merged caches, exclude predicted transcripts (i.e. those with identifiers beginning with \"XM_\" or \"XR_\")."
          },
          {
            "sbg:category": "Filtering and QC options",
            "id": "transcript_filter",
            "type": "string?",
            "inputBinding": {
              "prefix": "--transcript_filter",
              "shellQuote": false,
              "position": 15
            },
            "label": "Filter transcripts according to arbitrary rules",
            "doc": "Filter transcripts according to any arbitrary set of rules. Uses similar notation to filter_vep.  You may filter on any key defined in the root of the transcript object; most commonly this will be \"stable_id\":  --transcript_filter \"stable_id match N[MR]_\"."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "chromosome_select",
            "type": "string?",
            "inputBinding": {
              "prefix": "--chr",
              "shellQuote": false,
              "position": 15
            },
            "label": "Select a subset of chromosomes to analyse",
            "doc": "Select a subset of chromosomes to analyse from your file. Any data not on this chromosome in the input will be skipped. The list can be comma separated, with \"-\" characters representing an interval. For example, to include chromosomes 1, 2, 3, 10 and X you could use --chr 1-3,10,X Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "coding_only",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--coding_only",
              "shellQuote": false,
              "position": 15
            },
            "label": "Only return consequences that fall in the coding regions of transcripts",
            "doc": "Only return consequences that fall in the coding regions of transcripts. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "no_intergenic",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--no_intergenic",
              "shellQuote": false,
              "position": 15
            },
            "label": "Exclude intergenic consequences from the output",
            "doc": "Do not include intergenic consequences in the output. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "most_severe",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--most_severe",
              "shellQuote": false,
              "position": 15
            },
            "label": "Output only the most severe consequence per variant",
            "doc": "Output only the most severe consequence per variant. Transcript-specific columns will be left blank. Consequence ranks are given in this table. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "summary",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--summary",
              "shellQuote": false,
              "position": 15
            },
            "label": "Output only a comma-separated list of all observed consequences per variant",
            "doc": "Output only a comma-separated list of all observed consequences per variant. Transcript-specific columns will be left blank. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "filter_common",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--filter_common",
              "shellQuote": false,
              "position": 15
            },
            "label": "Exclude variants with a common (>1 % AF) co-located variant",
            "doc": "Shortcut flag for the filters below - this will exclude variants that have a co-located existing variant with global AF > 0.01 (1%). May be modified using any of the freq_* filters. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "pick",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--pick",
              "shellQuote": false,
              "position": 15
            },
            "label": "Pick one line or block of consequence data per variant, including transcript-specific columns",
            "doc": "Pick one line or block of consequence data per variant, including transcript-specific columns. Consequences are chosen according to the criteria described here, and the order the criteria are applied may be customised with --pick_order. This is the best method to use if you are interested only in one consequence per variant. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "pick_allele",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--pick_allele",
              "shellQuote": false,
              "position": 15
            },
            "label": "Pick one line or block of consequence data per variant allele",
            "doc": "Like --pick, but chooses one line or block of consequence data per variant allele. Will only differ in behaviour from --pick when the input variant has multiple alternate alleles. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "per_gene",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--per_gene",
              "shellQuote": false,
              "position": 15
            },
            "label": "Output only the most severe consequence per gene",
            "doc": "Output only the most severe consequence per gene. The transcript selected is arbitrary if more than one has the same predicted consequence. Uses the same ranking system as --pick. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "pick_allele_gene",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--pick_allele_gene",
              "shellQuote": false,
              "position": 15
            },
            "label": "Pick one line or block of consequence data per variant allele and gene combination",
            "doc": "Like --pick_allele, but chooses one line or block of consequence data per variant allele and gene combination. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "flag_pick",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--flag_pick",
              "shellQuote": false,
              "position": 15
            },
            "label": "Pick one line or block of consequence data per variant with PICK flag",
            "doc": "Pick one line or block of consequence data per variant, including transcript-specific columns, but add the PICK flag to the chosen block of consequence data and retains others. Not used by default.."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "flag_pick_allele",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--flag_pick_allele",
              "shellQuote": false,
              "position": 15
            },
            "label": "Pick one line or block of consequence data per variant allele, with PICK flag",
            "doc": "As per --pick_allele, but adds the PICK flag to the chosen block of consequence data and retains others. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "flag_pick_allele_gene",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--flag_pick_allele_gene",
              "shellQuote": false,
              "position": 15
            },
            "label": "Pick one line or block of consequence data per variant allele and gene combination, with PICK flag",
            "doc": "As per --pick_allele_gene, but adds the PICK flag to the chosen block of consequence data and retains others. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "canonical,appris,tsl,biotype,ccds,rank,length",
            "id": "pick_order",
            "type": "string[]?",
            "inputBinding": {
              "prefix": "--pick_order",
              "itemSeparator": ",",
              "shellQuote": false,
              "position": 15
            },
            "label": "Customise the order of criteria applied when picking a block of annotation data",
            "doc": "Customise the order of criteria applied when choosing a block of annotation data with e.g. --pick. Valid criteria are: canonical,appris,tsl,biotype,ccds,rank,length."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "check_frequency",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--check_frequency",
              "shellQuote": false,
              "position": 16
            },
            "label": "Use frequency filtering",
            "doc": "Turns on frequency filtering. Use this to include or exclude variants based on the frequency of co-located existing variants in the Ensembl Variation database. You must also specify all of the associated --freq_* flags. Frequencies used in filtering are added to the output under the FREQS key in the Extra field. Not used by default."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "freq_pop",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "1000 genomes combined population (global) [1KG_ALL]",
                  "1000 genomes combined African population [1KG_AFR]",
                  "1000 genomes combined American population [1KG_AMR]",
                  "1000 genomes combined East Asian population [1KG_EAS]",
                  "1000 genomes combined European population [1KG_EUR]",
                  "1000 genomes combined South Asian population [1KG_SAS]",
                  "NHLBI-ESP African American [ESP_AA]",
                  "NHLBI-ESP European American [ESP_EA]",
                  "ExAC combined population [ExAC]",
                  "ExAC combined adjusted population [ExAC_Adj]",
                  "ExAC African [ExAC_AFR]",
                  "ExAC American [ExAC_AMR]",
                  "ExAC East Asian [ExAC_EAS]",
                  "ExAC Finnish [ExAC_FIN]",
                  "ExAC non-Finnish European [ExAC_NFE]",
                  "ExAC South Asian [ExAC_SAS]",
                  "ExAC other [ExAC_OTH]"
                ],
                "name": "freq_pop"
              }
            ],
            "inputBinding": {
              "prefix": "--freq_pop",
              "shellQuote": false,
              "position": 16,
              "valueFrom": "${\n  if (inputs.freq_pop)\n  {\n    var tempout = inputs.freq_pop.split('[').pop(1);\n    tempout = tempout.split(']')[0];\n    return tempout;\n  }\n}"
            },
            "label": "Population to use in the frequency filter",
            "doc": "Name of the population to use in frequency filter."
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "Not used by default",
            "id": "freq_freq",
            "type": "float?",
            "inputBinding": {
              "prefix": "--freq_freq",
              "shellQuote": false,
              "position": 16
            },
            "label": "Allele frequency to use for filtering",
            "doc": "Allele frequency to use for filtering. Must be a float value between 0 and 1."
          },
          {
            "sbg:category": "Filtering and QC options",
            "id": "freq_gt_lt",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "greater than",
                  "less than"
                ],
                "name": "freq_gt_lt"
              }
            ],
            "inputBinding": {
              "prefix": "--freq_gt_lt",
              "shellQuote": false,
              "position": 16,
              "valueFrom": "${\n  if (inputs.freq_gt_lt)\n  {\n    if (inputs.freq_gt_lt=='greater than')\n    {\n      return 'gt';\n    }\n    else if (inputs.freq_gt_lt=='less than')\n    {\n      return 'lt';\n    }\n  }\n}"
            },
            "label": "Frequency cutoff operator",
            "doc": "Specify whether the frequency of the co-located variant must be greater than (gt) or less than (lt) the frequency filtering cutoff."
          },
          {
            "sbg:category": "Filtering and QC options",
            "id": "freq_filter",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "include",
                  "exclude"
                ],
                "name": "freq_filter"
              }
            ],
            "inputBinding": {
              "prefix": "--freq_filter",
              "shellQuote": false,
              "position": 16
            },
            "label": "Specify whether to exclude or include only variants that pass the frequency filter",
            "doc": "Specify whether to exclude or include only variants that pass the frequency filter."
          },
          {
            "sbg:category": "Input options",
            "sbg:toolDefaultValue": "Auto-detects",
            "id": "format",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "ensembl",
                  "vcf"
                ],
                "name": "format"
              }
            ],
            "inputBinding": {
              "prefix": "--format",
              "shellQuote": false,
              "position": 20
            },
            "label": "Input file format",
            "doc": "Input file format - one of \"ensembl\", \"vcf\", \"pileup\", \"hgvs\", \"id\". By default, the script auto-detects the input file format. Using this option you can force the script to read the input file as Ensembl, VCF, pileup or HGVS format, a list of variant identifiers (e.g. rsIDs from dbSNP), or the output from the VEP (e.g. to add custom annotation to an existing results file using --custom)."
          },
          {
            "sbg:category": "Input options",
            "id": "input_data",
            "type": "string?",
            "inputBinding": {
              "prefix": "--id",
              "shellQuote": false,
              "position": 20
            },
            "label": "Raw input data string",
            "doc": "Raw input data as a string. May be used, for example, to input a single rsID or HGVS notation quickly to vep: --input_data rs699."
          },
          {
            "sbg:category": "Input options",
            "sbg:toolDefaultValue": "variant_effect_output.txt_summary.html",
            "id": "stats_file",
            "type": "string?",
            "inputBinding": {
              "prefix": "--stats_file",
              "shellQuote": false,
              "position": 20,
              "valueFrom": "${\n  if (inputs.stats_file)\n  {\n    if (inputs.stats_text)\n    {\n      return inputs.stats_file.concat('_summary.txt');\n    }\n    else\n    {\n      return inputs.stats_file.concat('_summary.html');\n    }\n  }\n}"
            },
            "label": "Summary stats file name",
            "doc": "Summary stats file name. This is an HTML file containing a summary of the VEP run."
          },
          {
            "sbg:category": "Input options",
            "sbg:toolDefaultValue": "False",
            "id": "stats_text",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--stats_text",
              "shellQuote": false,
              "position": 20
            },
            "label": "Generate plain text stats file instead of HTML",
            "doc": "Generate a plain text stats file in place of the HTML."
          },
          {
            "sbg:category": "Other annotation sources",
            "sbg:toolDefaultValue": "False",
            "id": "use_given_ref_with_bam",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--use_given_ref",
              "shellQuote": false,
              "position": 45
            },
            "label": "Use user-provided ref allele with bam",
            "doc": "Use user-provided reference alleles when BAM files (--bam flag) are used on input."
          },
          {
            "sbg:category": "Other annotation sources",
            "sbg:toolDefaultValue": "False unless --bam is activated",
            "id": "use_transcript_ref",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--use_transcript_ref",
              "shellQuote": false,
              "position": 45
            },
            "label": "Override input reference allele with overlapped transcript ref allele",
            "doc": "By default VEP uses the reference allele provided in the user input to calculate consequences for the provided alternate allele(s). Use this flag to force VEP to replace the user-provided reference allele with sequence derived from the overlapped transcript. This is especially relevant when using the RefSeq cache, see documentation for more details. The GIVEN_REF and USED_REF fields are set in the output to indicate any change. Not used by default."
          },
          {
            "sbg:category": "Plugins",
            "sbg:toolDefaultValue": "False",
            "id": "use_LoFtool",
            "type": "boolean?",
            "inputBinding": {
              "shellQuote": false,
              "position": 100,
              "valueFrom": "${\n if (inputs.use_LoFtool== true)\n {\n   return \"--plugin LoFtool\";\n }\n else\n {\n   return \"\";\n }\n}"
            },
            "label": "Use LoFtool plugin",
            "doc": "Activates the use of the LoFtool plugin."
          },
          {
            "sbg:category": "Plugins",
            "sbg:toolDefaultValue": "False",
            "id": "use_MaxEntScan",
            "type": "boolean?",
            "inputBinding": {
              "shellQuote": false,
              "position": 100,
              "valueFrom": "${\n if (inputs.use_MaxEntScan== true)\n {\n   return \"--plugin MaxEntScan,/opt/vep/src/ensembl-vep/plugin-files\";\n }\n else\n {\n   return \"\";\n }\n}\n\n"
            },
            "label": "Use MaxEntScan plugin",
            "doc": "Activates the use of the MaxEntScan plugin."
          },
          {
            "sbg:category": "Plugins",
            "sbg:toolDefaultValue": "False",
            "id": "use_CSN",
            "type": "boolean?",
            "inputBinding": {
              "shellQuote": false,
              "position": 100,
              "valueFrom": "${\n if (inputs.use_CSN== true)\n {\n   return \"--plugin CSN\";\n }\n else\n {\n   return \"\";\n }\n}"
            },
            "label": "Use CSN plugin",
            "doc": "Activates the use of the CSN plugin."
          },
          {
            "sbg:toolDefaultValue": "tool-default-output-file-name",
            "id": "output_file_name",
            "type": "string?",
            "inputBinding": {
              "prefix": "--output_file",
              "shellQuote": false,
              "position": 10,
              "valueFrom": "${\n  if (inputs.in_variants[0] instanceof Array) {\n        var input_1 = inputs.in_variants[0][0] // scatter mode\n    } \n    else if (inputs.in_variants instanceof Array) {\n        var input_1 = inputs.in_variants[0]\n    } \n    else {\n        var input_1 = [].concat(inputs.in_variants)[0]\n    }\n    \n  if (inputs.output_file_name=='tool-default-output-file-name')\n  {\n    var fileName=input_1.path.split('/').pop();\n    var tempout=fileName.split('.vcf')[0];\n    if (inputs.output_format == 'tab')\n    {\n      tempout = tempout.concat('','.vep.tab');\n    }\n    else if (inputs.output_format == 'json')\n    {\n      tempout = tempout.concat('','.vep.json');\n    }\n    else if (inputs.compress_output)\n    {\n      tempout = tempout.concat('','.vep.vcf.gz');\n    }\n    else if (inputs.most_severe)\n    {\n      tempout = tempout.concat('','.vep.tab');\n    }\n    else\n    {\n      tempout = tempout.concat('','.vep.vcf');\n    }\n    return tempout;    \n  }\n  else\n  {\n    var tempout = inputs.output_file_name;\n    if (inputs.output_format == 'tab')\n    {\n      tempout = tempout.concat('','.vep.tab');\n    }\n    else if (inputs.output_format == 'json')\n    {\n      tempout = tempout.concat('','.vep.json');\n    }\n    else if (inputs.compress_output)\n    {\n      tempout = tempout.concat('','.vep.vcf.gz');\n    }\n    else\n    {\n      tempout = tempout.concat('','.vep.vcf');  \n    }\n    return tempout;\n  }\n}"
            },
            "label": "Output file name",
            "doc": "Output file name.",
            "default": "tool-default-output-file-name"
          },
          {
            "sbg:category": "Filtering and QC options",
            "sbg:toolDefaultValue": "False",
            "id": "lookup_ref",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--lookup_ref",
              "shellQuote": false,
              "position": 15
            },
            "label": "Overwrite the supplied reference allele",
            "doc": "Force overwrite the supplied reference allele with the sequence stored in the supplied reference FASTA file."
          },
          {
            "sbg:category": "Identifiers",
            "sbg:toolDefaultValue": "False",
            "id": "mane",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--mane",
              "shellQuote": false,
              "position": 8
            },
            "label": "Adds MANE identifiers",
            "doc": "Adds a flag indicating if the transcript is the MANE Select transcript for the gene."
          },
          {
            "sbg:category": "Basic options",
            "sbg:toolDefaultValue": "10MB",
            "id": "max_sv_size",
            "type": "int?",
            "inputBinding": {
              "prefix": "--max_sv_size",
              "shellQuote": false,
              "position": 1
            },
            "label": "Extend the maximum Structural Variant size",
            "doc": "Extend the maximum Structural Variant size VEP can process. By default, VEP only annotates variants with a size of up to 10MB. By increasing the maximum it will increase the memory requirements for annotation."
          },
          {
            "sbg:toolDefaultValue": "False",
            "sbg:category": "Basic options",
            "id": "no_check_variants_order",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--no_check_variants_order",
              "shellQuote": false,
              "position": 1
            },
            "label": "Permit the use of unsorted input files",
            "doc": "Set to True if running VEP on unsorted input files. This slows down the tool and requires more memory."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "overlaps",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--overlaps",
              "shellQuote": false,
              "position": 3
            },
            "label": "Transcript overlap",
            "doc": "Report the proportion and length of a transcript overlapped by a structural variant in VCF format."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "0",
            "id": "shift_3prime",
            "type": "int?",
            "inputBinding": {
              "prefix": "--shift_3prime",
              "shellQuote": false,
              "position": 6
            },
            "label": "Right align all variants",
            "doc": "Right aligns all variants relative to their associated transcripts prior to consequence calculation. Set to 1 for VEP to right align (default is 0)."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "0",
            "id": "shift_genomic",
            "type": "int?",
            "inputBinding": {
              "prefix": "--shift_genomic",
              "shellQuote": false,
              "position": 6
            },
            "label": "Right aligns all variants including intergenic variants",
            "doc": "Right aligns all variants, including intergenic variants, before consequence calculation and updates the Location field. To right align set the value to 1 (default is 0)."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "shift_length",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--shift_length",
              "shellQuote": false,
              "position": 6
            },
            "label": "Shifted distance",
            "doc": "Reports the distance each variant has been shifted when used in conjuction with --shift_3prime."
          },
          {
            "sbg:category": "Output options",
            "sbg:toolDefaultValue": "False",
            "id": "show_ref_allele",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--show_ref_allele",
              "shellQuote": false,
              "position": 6
            },
            "label": "Add reference allele in the output",
            "doc": "Adds the reference allele in the output. Mainly useful for the VEP \"default\" and tab-delimited output formats."
          },
          {
            "sbg:toolDefaultValue": "False",
            "sbg:category": "Identifiers",
            "id": "transcript_version",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--transcript_version",
              "shellQuote": false,
              "position": 8
            },
            "label": "Add transcript version",
            "doc": "Add version numbers to Ensembl transcript identifiers."
          },
          {
            "sbg:toolDefaultValue": "False",
            "sbg:category": "Co-located variants",
            "id": "var_synonyms",
            "type": "boolean?",
            "inputBinding": {
              "prefix": "--var_synonyms",
              "shellQuote": false,
              "position": 8
            },
            "label": "Report known synonyms for colocated variants",
            "doc": "Report known synonyms for colocated variants."
          },
          {
            "sbg:category": "Config Inputs",
            "id": "species",
            "type": "string?",
            "inputBinding": {
              "prefix": "--species",
              "shellQuote": false,
              "position": 10
            },
            "label": "Species",
            "doc": "Species."
          }
        ],
        "outputs": [
          {
            "id": "vep_output_file",
            "doc": "Output file (annotated VCF) from VEP.",
            "label": "VEP output file",
            "type": "File?",
            "outputBinding": {
              "glob": "{*.vep.vcf,*.vep.json,*.vep.txt,*.vep.tab}",
              "outputEval": "$(inheritMetadata(self, inputs.in_variants))"
            },
            "sbg:fileTypes": "VCF, TXT, JSON, TAB"
          },
          {
            "id": "compressed_vep_output",
            "doc": "Compressed (bgzip/gzip) output.",
            "label": "Compressed (bgzip/gzip) output",
            "type": "File?",
            "outputBinding": {
              "glob": "*.vep.*gz",
              "outputEval": "$(inheritMetadata(self, inputs.in_variants))"
            },
            "sbg:fileTypes": "GZ"
          },
          {
            "id": "summary_file",
            "doc": "Summary stats file, if requested.",
            "label": "Output summary stats file",
            "type": "File?",
            "outputBinding": {
              "glob": "*summary.*",
              "outputEval": "$(inheritMetadata(self, inputs.in_variants))"
            },
            "sbg:fileTypes": "HTML, TXT"
          },
          {
            "id": "warning_file",
            "doc": "Optional file with VEP warnings and errors.",
            "label": "Optional file with VEP warnings and errors",
            "type": "File?",
            "outputBinding": {
              "glob": "*_warnings.txt"
            },
            "sbg:fileTypes": "TXT"
          }
        ],
        "doc": "**Variant Effect Predictor** predicts functional effects of genomic variants [1] and is used to annotate VCF files.\n\n**Variant Effect Predictor** determines the effect of your variants (SNPs, insertions, deletions, CNVs or structural variants) on genes, transcripts, and protein sequence, as well as regulatory regions [2].\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Variant Effect Predictor** is a tool commonly used for variant and gene level annotation of VCF or VCF.GZ files. Running the tool on the Seven Bridges platform requires using a VEP cache file. VEP cache files can be obtained from our **Public Reference Files** section (`homo_sapiens_vep_101_GRCh37.indexed.tar.gz` and `homo_sapiens_vep_101_GRCh38.indexed.tar.gz`) or imported as files to your project from [Ensembl ftp site](ftp://ftp.ensembl.org/pub/release-101/variation/indexed_vep_cache/) using the [FTP/HTTP import](https://docs.sevenbridges.com/docs/upload-from-an-ftp-server) feature.\n\n### Changes Introduced by Seven Bridges\n\n- Additional boolean flags are introduced to activate the use of plugins included in the Seven Bridges version of the tool (CSN, MaxEntScan, and LoFtool plugins can be accessed with parameters **Use CSN plugin**, **Use MaxEntScan plugin**, and **Use LoFtool plugin**, respectively).\n- When using custom annotation sources (`--custom` flag) input files and parameters are specified separately and both must be provided to run the tool (inputs **Custom annotation sources** and **Annotation parameters for custom annotation sources (comma separated values, ensembl-vep --custom flag format)**). Additionally, separate inputs have been provided for BigWig custom annotation sources and parameters, as these files do not require indexing before use (inputs **Custom annotation - BigWig sources only** and **Annotation parameters for custom BigWig annotation sources only**). Tabix TBI indices are required for other custom annotation sources.\n- The following parameters have been excluded from the Seven Bridges version of the tool:\n    * `--help`: Not present in the Seven Bridges version in general.\n    * `--quiet`: Warnings are desirable.\n    * `--species [species]`: Relevant only if **Variant Effect Predictor** is connecting to the Ensembl database online, which is not the case with the tool on the Platform.\n    * `--force_overwrite`: Overwriting existing output, which is not likely to be found on the Seven Bridges Platform.\n    * `--dir_cache [directory]`, `--dir_plugins [directory]`: Covered with a more general flag (`--dir`).\n    * `--cache`: The `--offline` argument is always used instead.\n    * `--format:` argument with its corresponding suboptions `hgvs`, and `id`. These options require an Ensembl database connection.\n    * `--show_cache_info`: This option only shows cache info and quits.\n    * `--plugin [plugin name]`: Several plugins are supplied in the **Variant Effect Predictor** tool on the Platform (e.g. dbNSFP [4], CSN, MaxEntScan, LoFtool). However, this option was not wrapped because, in order to use any plugin, it must be installed on the **Variant Effect Predictor** Docker image. Additional plugins can be added upon request.\n    * `--phased`: Used with plugins requiring phased data. No such plugins are present in the wrapper.\n    * `--database`: Database access-only option\n    * `--host [hostname]`: Database access-only option\n    * `--user [username]`: Database access-only option\n    * `--port [number]`: Database access-only option\n    * `--password [password]`: Database access-only option\n    * `--genomes`: Database access-only option\n    * `--lrg`: Database access-only option\n    * `--check_svs`: Database access-only option\n    * `--db_version [number]`: Database access-only option\n    * `--registry [filename]`: Database access-only option\n\n### Common Issues and Important Notes\n \n* Inputs **Input VCF** (`--input_file`) and **Species cache** files are required. They represent a variant file containing variants to be annotated and a database cache file used for annotating the most common variants found in the particular species, respectively. The cache file reduces the need to send requests to an outside **Variant Effect Predictor** relevant annotation database, which is usually located online.   \n* **Fasta file(s) to use to look up reference sequences** (`--fasta`) is not required, however, it is highly recommended when using **Variant Effect Predictor** in offline mode which requires a FASTA file for several annotations.\n* Please see flag descriptions or official documentation [3] for detailed descriptions of limitations.\n* The **Add gnomAD allele frequencies (or ExAc frequencies with cache < 90)** (`--af_exac` or `--af_gnomAD`) parameter should be set: Please note that ExAC data has been superseded by gnomAD data and is only accessible with older (<90) cache versions. The Seven Bridges version of the tool will automatically swap flags according to the cache version reported.\n* The **Include Ensembl identifiers when using RefSeq and merged caches** (`--all_refseq`) and **Exclude predicted transcripts when using RefSeq or merged cache** (`--exclude_predicted`) parameters should only be used with RefSeq or merged caches\n* The **Add APPRIS identifiers** (`--appris`) parameter - APPRIS is only available for GRCh38.\n* The **Fields to configure the output format (VCF or tab only) with** (`--fields`) parameter \n can only be used with VCF and TSV output.\n* The **Samples to annotate** (`--individual`) parameter requires that all samples of interest have proper genotype entries for all variant rows in the file. **Variant Effect Predictor** will not output multiple variant rows per sample if genotypes are missing in those rows.\n* If dbNSFP [4] is used for annotation, a preprocessed dbNSFP file (input **dbNSFP database file**) and dbNSFP column names (parameter **Columns of dbNSFP to report**) should be provided. dbNSFP column names should match the release of dbNSFP provided for annotation (for a detailed list of column names, please consult the [readme files accompanying the dbNSFP release](https://sites.google.com/site/jpopgen/dbNSFP) used for annotation). If no dbNSFP column names are provided alongside a dbNSFP annotation file, the following example subset of columns applicable to dbNSFP versions 2.9.3, 3.Xc and 4.0c will be used for annotation: `FATHMM_pred,MetaSVM_pred,GERP++_RS`.\n * If using dbscSNV for annotation, a dbscSNV file (input **dbscSNV database file**) should be provided.\n* The **Version of VEP cache if not default** parameter (`--cache_version`) must be supplied if not using a VEP 101 cache.\n* If using custom annotation sources (input **Custom annotation sources**), corresponding parameters (input **Annotation parameters for custom annotation sources (comma separated values, ensembl-vep --custom flag format)**) must be set and must match the order of supplied input files.\n* Input parameter **Output only the most severe consequence per variant** (`--most_severe`) is incompatible with **Output format** `vcf`. Using this parameter produces a tab-separated output file.\n\nThe input files **GFF annotation** (`--gff`) and **GTF annotation** (`--gtf`), which are used for transcript annotation, should be bgzipped (using the **Tabix Bgzip** tool) and tabix-indexed (using the **Tabix Index** tool), and a FASTA file containing genomic sequences is required (input **Fasta file(s) to use to look up reference sequence**). If preprocessing these files locally, implement the following [1]:\n\n    grep -v \"#\" data.gff | sort -k1,1 -k4,4n -k5,5n | bgzip -c > data.gff.gz\n\n    tabix -p gff data.gff.gz\n\n\n### Performance Benchmarking\n\nPerformance of **Variant Effect Predictor** will vary greatly depending on the annotation options selected and input file size. Increasing the number of forks used with the parameter **Fork number** (`--fork`) and the number of processors will help. Additionally, tabix-indexing your supplied FASTA file, or setting the **Do not generate a stats file** (`--no_stats`) flag will speed up annotation. Preprocessing the VEP cache using the **convert_cache.pl** script included in the **ensembl-vep distribution** will also help if using **Check for co-located known variants** (`--check_existing`) flag or any of the allele frequency associated flags. VEP caches available on the Seven Bridges Platform are indexed Ensembl VEP cache files obtained directly from their [ftp repository](ftp://ftp.ensembl.org/pub/release-100/variation/indexed_vep_cache/).\nUsing **Add HGVS identifiers** (`--hgvs`) parameter will slow down the annotation process.\n\nIn the following table you can find estimates of **Variant Effect Predictor** running time and cost. The sample that was annotated was NA12878 genome (~100 Mb, as VCF.GZ).\n\n*Cost can be significantly reduced by **spot instance** usage. Visit [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*            \n\n                   \n| Experiment type  | Duration | Cost | Instance (AWS)|\n|-----------------------|-----------------|------------|-----------------|-------------|--------------|------------------|-------------|---------------|\n| All available annotations, all plugins and dbNSFP4.0c   | 3h 28 min   | $1.79            |c4.2xlarge      |\n| Basic annotations, without plugins and dbNSFP4.0c  | 37 min    | $0.23                | c4.2xlarge     |\n\n\n### References\n\n[1] [Ensembl Variant Effect Predictor github page](https://github.com/Ensembl/ensembl-vep)\n\n[2] [Homepage](http://www.ensembl.org/info/docs/tools/vep/script/index.html)\n\n[3] [Running VEP - Documentation page](https://www.ensembl.org/info/docs/tools/vep/script/vep_options.html)\n\n[4] [dbNSFP](https://sites.google.com/site/jpopgen/dbNSFP)",
        "label": "Variant Effect Predictor CWL1.0",
        "arguments": [
          {
            "prefix": "",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "${ return \"tar xfz\";\n}"
          },
          {
            "prefix": "",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "$(inputs.cache_file.path)"
          },
          {
            "prefix": "",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "${ return \"-C /opt/vep/src/ensembl-vep/ &&\";\n}"
          },
          {
            "prefix": "",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "${\n  return \"perl -I /root/.vep/Plugins/\";\n}"
          },
          {
            "prefix": "",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "${ return \"/opt/vep/src/ensembl-vep/vep\";\n}"
          },
          {
            "prefix": "",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "--offline"
          },
          {
            "prefix": "--dir",
            "shellQuote": false,
            "position": 0,
            "valueFrom": "/opt/vep/src/ensembl-vep"
          },
          {
            "prefix": "",
            "shellQuote": false,
            "position": 1000,
            "valueFrom": "${\n  if ((!inputs.no_stats) && (!inputs.stats_text))\n  {\n    return \"; sed -i 's=http:\\/\\/www.google.com\\/jsapi=https:\\/\\/www.google.com\\/jsapi=g' *summary.html\";\n  }\n}"
          }
        ],
        "requirements": [
          {
            "class": "ShellCommandRequirement"
          },
          {
            "class": "ResourceRequirement",
            "ramMin": "${\n  if(inputs.memory_for_job>0)\n  \treturn inputs.memory_for_job;\n  else\n    return 15000;\n}",
            "coresMin": "${\n  if(inputs.cpu_per_job>0)\n  \treturn inputs.cpu_per_job;\n  else\n    return 8;\n}"
          },
          {
            "class": "DockerRequirement",
            "dockerPull": "images.sbgenomics.com/lea_lenhardt_ackovic/ensembl-vep-101-0:0"
          },
          {
            "class": "InlineJavascriptRequirement",
            "expressionLib": [
              "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file))\n        file['metadata'] = metadata;\n    else {\n        for (var key in metadata) {\n            file['metadata'][key] = metadata[key];\n        }\n    }\n    return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n    return o1;\n};",
              "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file)) {\n        file['metadata'] = {}\n    }\n    for (var key in metadata) {\n        file['metadata'][key] = metadata[key];\n    }\n    return file\n};\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!o2) {\n        return o1;\n    };\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n        for (var key in commonMetadata) {\n            if (!(key in example)) {\n                delete commonMetadata[key]\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n        if (o1.secondaryFiles) {\n            o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)\n        }\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n            if (o1[i].secondaryFiles) {\n                o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)\n            }\n        }\n    }\n    return o1;\n};"
            ]
          }
        ],
        "sbg:toolkit": "ensembl-vep",
        "sbg:toolkitVersion": "101.0",
        "sbg:links": [
          {
            "id": "https://github.com/Ensembl/ensembl-vep",
            "label": "Source Code"
          },
          {
            "id": "http://www.ensembl.org/info/docs/tools/vep/script/index.html",
            "label": "Homepage"
          },
          {
            "id": "https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0974-4",
            "label": "Publication"
          }
        ],
        "sbg:toolAuthor": "Ensembl",
        "sbg:license": "Modified Apache licence",
        "sbg:categories": [
          "Annotation",
          "VCF Processing",
          "CWL1.0"
        ],
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1617277719,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1617277806,
            "sbg:revisionNotes": "Final version"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1617277806,
            "sbg:revisionNotes": "Default for cache version edited"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1617277806,
            "sbg:revisionNotes": "Description edited"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1617277806,
            "sbg:revisionNotes": "Output filename JS edited for array of files."
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1617277806,
            "sbg:revisionNotes": "Metadata inheritance for summary file added."
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1625490165,
            "sbg:revisionNotes": "Added --species input"
          }
        ],
        "sbg:image_url": null,
        "sbg:projectName": "SBG Public data",
        "sbg:expand_workflow": false,
        "sbg:appVersion": [
          "v1.0"
        ],
        "sbg:id": "admin/sbg-public-data/variant-effect-predictor-101-0-cwl1-0/6",
        "sbg:revision": 6,
        "sbg:revisionNotes": "Added --species input",
        "sbg:modifiedOn": 1625490165,
        "sbg:modifiedBy": "admin",
        "sbg:createdOn": 1617277719,
        "sbg:createdBy": "admin",
        "sbg:project": "admin/sbg-public-data",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "admin"
        ],
        "sbg:latestRevision": 6,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "ad60fb9e6f4497fe114cce135b8e10c6c0cf0fd2d7675a5078492d29d98cf7d26"
      },
      "label": "Variant Effect Predictor CWL1.0",
      "sbg:x": 235.85000610351562,
      "sbg:y": -37.45000076293945
    },
    {
      "id": "bcftools_consensus",
      "in": [
        {
          "id": "input_file",
          "source": "variant_effect_predictor_101_0_cwl1_0/vep_output_file"
        },
        {
          "id": "reference",
          "source": "reference"
        }
      ],
      "out": [
        {
          "id": "output_file"
        }
      ],
      "run": {
        "cwlVersion": "sbg:draft-2",
        "class": "CommandLineTool",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "id": "admin/sbg-public-data/bcftools-consensus/4",
        "label": "Bcftools Consensus",
        "description": "**BCFtools Consensus**: Create a consensus sequence by applying VCF variants to a reference FASTA file. \n\n\n**BCFtools** is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart BCF. All commands work transparently with both VCFs and BCFs, both uncompressed and BGZF-compressed. Most commands accept VCF, bgzipped VCF and BCF with filetype detected automatically even when streaming from a pipe. Indexed VCF and BCF will work in all situations. Un-indexed VCF and BCF and streams will work in most, but not all situations. In general, whenever multiple VCFs are read simultaneously, they must be indexed and therefore also compressed. [1]\n\nA list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.\n\n\n### Common Use Cases\n\nBy default, the program will apply all ALT variants to the reference FASTA to obtain the consensus sequence. Can be also used with the **SAMtools Faidx** tool where the desired part of reference can be extracted and then provided  to this tool.\n\n\nUsing the **Sample** (`--sample`) (and, optionally, **Haplotype** (`--haplotype`) option will apply genotype (haplotype) calls from FORMAT/GT. \n```\n$bcftools consensus -s NA001 -f in.fa in.vcf.gz > out.fa\n```\n\nApply variants present in sample \"NA001\", output IUPAC codes using **Output in IUPAC** (`--iupac-codes`) option\n```\nbcftools consensus --iupac-codes -s NA001 -f in.fa in.vcf.gz > out.fa\n```\n\n### Changes Introduced by Seven Bridges\n\n* BCFtools works in all cases with gzipped and indexed VCF/BCF files. To be sure BCFtools works in all cases, we added subsequet bgzip and index commands if a VCF file is provided on input. If VCF.GZ is given on input only indexing will be done. Output type can still be chosen with the `output type` command.\n\n### Common Issues and Important Notes\n\n* By default, the program will apply all ALT variants to the reference FASTA to obtain the consensus sequence. \n\n * If the FASTA sequence does not match the REF allele at a given position, the tool will fail.\n\n### Performance Benchmarking\n\nIt took 5 minutes to execute this tool on AWS c4.2xlarge instance with a 56 KB VCF and a 3 GB reference FASTA file. The price is negligible ($0.02).\n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*\n\n### References\n[1 - BCFtools page](https://samtools.github.io/bcftools/bcftools.html)",
        "baseCommand": [
          {
            "class": "Expression",
            "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\")\n    return \"bcftools index  -f -t \" + fname + \".gz &&\"\n  }\n  else{\n  \n    return \"bgzip -c -f \" + fname + \" > \" + fname + \".gz\" + \" && bcftools index -f -t \" + fname + \".gz &&\"\n  \n  }\n  \n  \n  \n}",
            "engine": "#cwl-js-engine"
          },
          "bcftools",
          "consensus"
        ],
        "inputs": [
          {
            "sbg:stageInput": "link",
            "sbg:category": "File Input",
            "type": [
              "File"
            ],
            "inputBinding": {
              "position": 40,
              "separate": true,
              "valueFrom": {
                "class": "Expression",
                "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\")\n    return fname + \".gz\"\n  }\n  else{\n  \n    return fname + \".gz\"\n  \n  }\n  \n  \n  \n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:cmdInclude": true
            },
            "label": "Input file",
            "description": "Input VCF file.",
            "sbg:fileTypes": "VCF, VCF.GZ",
            "id": "#input_file"
          },
          {
            "sbg:altPrefix": "-i",
            "sbg:category": "General Options",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 5,
              "prefix": "--include",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Include expression",
            "description": "Include only sites for which the expression is true.",
            "id": "#include_expression"
          },
          {
            "sbg:altPrefix": "-e",
            "sbg:category": "General Options",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 1,
              "prefix": "--exclude",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Exclude expression",
            "description": "Exclude sites for which the expression is true.",
            "id": "#exclude_expression"
          },
          {
            "sbg:category": "Configuration",
            "type": [
              "null",
              "string"
            ],
            "label": "Output file name",
            "description": "Name of the output file.",
            "id": "#output_name"
          },
          {
            "sbg:altPrefix": "-s",
            "sbg:category": "General Options",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 20,
              "prefix": "--sample",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Sample",
            "description": "Apply variants of the given sample.",
            "id": "#sample"
          },
          {
            "sbg:toolDefaultValue": "1",
            "sbg:stageInput": null,
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Number of CPUs",
            "description": "Number of CPUs. Appropriate instance will be chosen based on this parameter.",
            "id": "#cpu"
          },
          {
            "sbg:toolDefaultValue": "1000",
            "sbg:stageInput": null,
            "sbg:category": "Execution",
            "type": [
              "null",
              "int"
            ],
            "label": "Memory in MB",
            "description": "Memory in MB. Appropriate instance will be chosen based on this parameter.",
            "id": "#memory"
          },
          {
            "sbg:altPrefix": "-c",
            "sbg:category": "General Options",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "--chain",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Chain file",
            "description": "A chain file for liftover.",
            "id": "#chain"
          },
          {
            "sbg:altPrefix": "-f",
            "type": [
              "File"
            ],
            "inputBinding": {
              "position": 2,
              "prefix": "--fasta-ref",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Reference Genome",
            "description": "Reference sequence in fasta format.",
            "sbg:fileTypes": "FASTA",
            "id": "#reference"
          },
          {
            "sbg:altPrefix": "-h",
            "sbg:category": "General Options",
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "1",
                  "2",
                  "R",
                  "A",
                  "LR,LA",
                  "SR,SA"
                ],
                "name": "haplotype"
              }
            ],
            "inputBinding": {
              "position": 4,
              "prefix": "--haplotype",
              "separate": true,
              "valueFrom": {
                "class": "Expression",
                "script": "{\n\n  if($job.inputs.haplotype == '1'){return \"1\"}\n  if($job.inputs.haplotype == '2'){return \"2\"}\n  if($job.inputs.haplotype == 'R'){return \"R\"}\n  if($job.inputs.haplotype == 'A'){return \"A\"}\n  if($job.inputs.haplotype == 'LR,LA'){return \"LR,LA\"}\n  if($job.inputs.haplotype == 'SR,SA'){return \"SR,SA\"}\n\n\n\n\n\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:cmdInclude": true
            },
            "label": "Haplotype",
            "description": "Choose which allele to use from the FORMAT/GT field.",
            "id": "#haplotype"
          },
          {
            "sbg:altPrefix": "-I",
            "sbg:category": "General Options",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 6,
              "prefix": "--iupac-codes",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Output in IUPAC",
            "description": "Output variants in the form of IUPAC ambiguity codes.",
            "id": "#iupac"
          },
          {
            "sbg:altPrefix": "-m",
            "sbg:category": "General Options",
            "type": [
              "null",
              "File"
            ],
            "inputBinding": {
              "position": 7,
              "prefix": "--mask",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Mask file",
            "description": "Replace regions with N.",
            "id": "#mask"
          },
          {
            "sbg:altPrefix": "-M",
            "sbg:category": "General Options",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 8,
              "prefix": "--missing",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Missing genotypes",
            "description": "Output <char> instead of skipping the missing genotypes.",
            "id": "#missing"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "label": "Output file",
            "description": "Consensus sequence",
            "sbg:fileTypes": "VCF, BCF, VCF.GZ, BCF.GZ",
            "outputBinding": {
              "glob": {
                "class": "Expression",
                "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\").split('.vcf')[0]\n  }\n  \n  else{\n  \n  fname = fname.replace(/\\.[^/.]+$/, \"\")\n  \n  }\n  \n  \n  return fname + \".fa\"\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:inheritMetadataFrom": "#input_file"
            },
            "id": "#output_file"
          }
        ],
        "requirements": [
          {
            "class": "ExpressionEngineRequirement",
            "requirements": [
              {
                "class": "DockerRequirement",
                "dockerPull": "rabix/js-engine"
              }
            ],
            "id": "#cwl-js-engine"
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": {
              "class": "Expression",
              "script": "{\n  if($job.inputs.cpu){\n    return $job.inputs.cpu}\n  else{\n    return 1}\n}",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "class": "sbg:MemRequirement",
            "value": {
              "class": "Expression",
              "script": "{\n  if($job.inputs.memory){\n    return $job.inputs.memory}\n  else{\n    return 1000}\n}    ",
              "engine": "#cwl-js-engine"
            }
          },
          {
            "class": "DockerRequirement",
            "dockerImageId": "21caaa02f72e",
            "dockerPull": "images.sbgenomics.com/luka_topalovic/bcftools:1.9"
          }
        ],
        "arguments": [
          {
            "position": 3,
            "prefix": "--output",
            "separate": true,
            "valueFrom": {
              "class": "Expression",
              "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\").split('.vcf')[0]\n  }\n  \n  else{\n  \n  fname = fname.replace(/\\.[^/.]+$/, \"\")\n  \n  }\n  \n  \n  return fname + \".fa\"\n}",
              "engine": "#cwl-js-engine"
            }
          }
        ],
        "sbg:toolkitVersion": "1.9",
        "abg:revisionNotes": "Initial version",
        "sbg:image_url": null,
        "sbg:license": "MIT License",
        "sbg:toolAuthor": "Petr Danecek, Shane McCarthy, John Marshall",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1538758819,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1538758819,
            "sbg:revisionNotes": "Initial"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1538758819,
            "sbg:revisionNotes": "Description"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1538758819,
            "sbg:revisionNotes": "Description"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "admin",
            "sbg:modifiedOn": 1561459470,
            "sbg:revisionNotes": "Updated default CPU and memory parameter"
          }
        ],
        "sbg:categories": [
          "VCF-Processing"
        ],
        "sbg:toolkit": "bcftools",
        "sbg:job": {
          "allocatedResources": {
            "mem": 10000,
            "cpu": 8
          },
          "inputs": {
            "exclude_expression": "",
            "cpu": null,
            "reference": {
              "class": "File",
              "secondaryFiles": [],
              "path": "/path/to/reference.ext",
              "size": 0
            },
            "input_file": {
              "class": "File",
              "secondaryFiles": [
                {
                  "path": ".tbi"
                }
              ],
              "path": "/path/to/input_file.vcf.gz",
              "size": 0
            },
            "missing": "",
            "output_name": "",
            "memory": null,
            "sample": "",
            "include_expression": "",
            "haplotype": null,
            "iupac": false
          }
        },
        "sbg:projectName": "SBG Public data",
        "sbg:cmdPreview": "bcftools index  -f -t input_file.vcf.gz && bcftools consensus --fasta-ref /path/to/reference.ext --output input_file.fa  input_file.vcf.gz",
        "sbg:links": [
          {
            "id": "http://samtools.github.io/bcftools/",
            "label": "Homepage"
          },
          {
            "id": "https://github.com/samtools/bcftools",
            "label": "Source code"
          },
          {
            "id": "https://github.com/samtools/bcftools/wiki",
            "label": "Wiki"
          },
          {
            "id": "https://github.com/samtools/bcftools/archive/1.9.zip",
            "label": "Download"
          }
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:id": "admin/sbg-public-data/bcftools-consensus/4",
        "sbg:revision": 4,
        "sbg:revisionNotes": "Updated default CPU and memory parameter",
        "sbg:modifiedOn": 1561459470,
        "sbg:modifiedBy": "admin",
        "sbg:createdOn": 1538758819,
        "sbg:createdBy": "admin",
        "sbg:project": "admin/sbg-public-data",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "admin"
        ],
        "sbg:latestRevision": 4,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a1b92f933e91d110714fdf1f6285b06b38d826e88f77c0f8798e9eecc40b4afa5"
      },
      "label": "Bcftools Consensus",
      "sbg:x": 439.6000061035156,
      "sbg:y": -175.75
    }
  ],
  "requirements": [
    {
      "class": "InlineJavascriptRequirement"
    },
    {
      "class": "StepInputExpressionRequirement"
    }
  ],
  "sbg:projectName": "COVID-19",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626776980,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626777025,
      "sbg:revisionNotes": ""
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626833024,
      "sbg:revisionNotes": "with GATK MergeVCFs"
    },
    {
      "sbg:revision": 3,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626837561,
      "sbg:revisionNotes": "with SnpSift Annotate"
    },
    {
      "sbg:revision": 4,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626838638,
      "sbg:revisionNotes": "with snpEff"
    },
    {
      "sbg:revision": 5,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626839183,
      "sbg:revisionNotes": "setting in assembly"
    },
    {
      "sbg:revision": 6,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626843044,
      "sbg:revisionNotes": "with BWA"
    },
    {
      "sbg:revision": 7,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626844166,
      "sbg:revisionNotes": "with MarkDuplicates"
    },
    {
      "sbg:revision": 8,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626852758,
      "sbg:revisionNotes": "with SAMtools+MergeBamAlignment"
    },
    {
      "sbg:revision": 9,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626855299,
      "sbg:revisionNotes": "with remove duplication option activate"
    },
    {
      "sbg:revision": 10,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626855957,
      "sbg:revisionNotes": ""
    },
    {
      "sbg:revision": 11,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626858806,
      "sbg:revisionNotes": "with 2 exposed in MarkDuplicates CWL 1.0"
    },
    {
      "sbg:revision": 12,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626935703,
      "sbg:revisionNotes": "with samtools"
    },
    {
      "sbg:revision": 13,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626935924,
      "sbg:revisionNotes": "setting done"
    },
    {
      "sbg:revision": 14,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626939386,
      "sbg:revisionNotes": ""
    },
    {
      "sbg:revision": 15,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626939424,
      "sbg:revisionNotes": ""
    },
    {
      "sbg:revision": 16,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626941887,
      "sbg:revisionNotes": "with GATK CollectAlignment, without reference file"
    },
    {
      "sbg:revision": 17,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1626942237,
      "sbg:revisionNotes": "GATK CollectAlignment along with reference file"
    },
    {
      "sbg:revision": 18,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627028244,
      "sbg:revisionNotes": "with VEP"
    },
    {
      "sbg:revision": 19,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627029287,
      "sbg:revisionNotes": "additional input file"
    },
    {
      "sbg:revision": 20,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627030489,
      "sbg:revisionNotes": "with more output and par setting in VEP"
    },
    {
      "sbg:revision": 21,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627292325,
      "sbg:revisionNotes": "with duplication detection"
    },
    {
      "sbg:revision": 22,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627293293,
      "sbg:revisionNotes": "with Picard MarkDuplicate"
    },
    {
      "sbg:revision": 23,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627295155,
      "sbg:revisionNotes": "with output"
    },
    {
      "sbg:revision": 24,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627462387,
      "sbg:revisionNotes": "alignment+variant calling+ annotation"
    },
    {
      "sbg:revision": 25,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627544552,
      "sbg:revisionNotes": "with pairing option activated"
    },
    {
      "sbg:revision": 26,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627633536,
      "sbg:revisionNotes": "with only one variant viewed + variant class setting"
    },
    {
      "sbg:revision": 27,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627975684,
      "sbg:revisionNotes": "without batching mode+genome coverage+fastQC"
    },
    {
      "sbg:revision": 28,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1627977445,
      "sbg:revisionNotes": "with FastQC"
    },
    {
      "sbg:revision": 29,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630129162,
      "sbg:revisionNotes": "changed with bowtie"
    },
    {
      "sbg:revision": 30,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630130325,
      "sbg:revisionNotes": "new positioning of FastQC"
    },
    {
      "sbg:revision": 31,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630133865,
      "sbg:revisionNotes": "preprocessed into bam file"
    },
    {
      "sbg:revision": 32,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630134076,
      "sbg:revisionNotes": "changed in sort order parameter"
    },
    {
      "sbg:revision": 33,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630134861,
      "sbg:revisionNotes": "with fastqc"
    },
    {
      "sbg:revision": 34,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630135662,
      "sbg:revisionNotes": "without MarkDuplicates"
    },
    {
      "sbg:revision": 35,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630137692,
      "sbg:revisionNotes": "just SortSam"
    },
    {
      "sbg:revision": 36,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1630138999,
      "sbg:revisionNotes": "variant calling + VEP"
    },
    {
      "sbg:revision": 37,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1631609947,
      "sbg:revisionNotes": "optimized for FASTA input files"
    },
    {
      "sbg:revision": 38,
      "sbg:modifiedBy": "hendrick.san",
      "sbg:modifiedOn": 1636642746,
      "sbg:revisionNotes": "Variant Caller Fix"
    }
  ],
  "sbg:image_url": "https://cgc.sbgenomics.com/ns/brood/images/hendrick.san/covid19/sbg-fasta-indices-haplotype-caller/38.png",
  "sbg:appVersion": [
    "v1.2",
    "sbg:draft-2",
    "v1.0"
  ],
  "id": "https://cgc-api.sbgenomics.com/v2/apps/hendrick.san/covid19/sbg-fasta-indices-haplotype-caller/38/raw/",
  "sbg:id": "hendrick.san/covid19/sbg-fasta-indices-haplotype-caller/38",
  "sbg:revision": 38,
  "sbg:revisionNotes": "Variant Caller Fix",
  "sbg:modifiedOn": 1636642746,
  "sbg:modifiedBy": "hendrick.san",
  "sbg:createdOn": 1626776980,
  "sbg:createdBy": "hendrick.san",
  "sbg:project": "hendrick.san/covid19",
  "sbg:sbgMaintained": false,
  "sbg:validationErrors": [],
  "sbg:contributors": [
    "hendrick.san"
  ],
  "sbg:latestRevision": 38,
  "sbg:publisher": "sbg",
  "sbg:content_hash": "a51fb13f9a09b7d8cf4fd521bf8486109b9a80dc35fd4464b4e4f44da4aa180fc",
  "sbg:workflowLanguage": "CWL"
}
