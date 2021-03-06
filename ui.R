library(shinythemes)

# Define UI for application that displays GEO results based on user choices
ui <- shinyUI(fluidPage(theme = shinytheme("lumen"), 
                        #h1(strong("REALGAR"), align="center", style = "color: #9E443A;"),
                        h3(strong("Reducing Associations by Linking Genes And transcriptomic Results (REALGAR)"), align="center", style = "color: #9E443A;"), hr(),
                        p("REALGAR is a tissue-specific, disease-focused resource for integrating omics results. ",
                          "This app brings together genome-wide association study (GWAS) results from ",
                          a("EVE", href="http://eve.uchicago.edu/", target="_blank"), ", ",
                          a("GABRIEL", href="https://www.cng.fr/gabriel/index.html", target="_blank"), "and ",
                          a("GRASP,", href="https://grasp.nhlbi.nih.gov/Search.aspx", target="_blank"), 
                          " transcript data from ",
                          a("GENCODE,", href="http://www.gencodegenes.org/", target="_blank"),
                          " and glucocorticoid receptor binding sites from ",
                          a("UCSC's ENCODE,", href="https://genome.ucsc.edu/ENCODE/", target="_blank"),
                          "with microarray gene expression and gene-level RNA-Seq results from the ", 
                          a("Gene Expression Omnibus (GEO),", href="http://www.ncbi.nlm.nih.gov/geo/", target="_blank"),
                          " allowing researchers to access a breadth of information with a click. ",
                          "Gene expression results, SNPs and glucocorticoid receptor DNA binding sites can be viewed in the 'Results' tab. ",
                          "The 'Datasets loaded' tab contains (1) GEO accession numbers that link directly to GEO entries, ", 
                          "(2) PMIDs for papers, when available, that link directly to PubMed entries, and ", 
                          "(3) brief descriptions for all datasets that match selected criteria. ",
                          "The RNA-Seq results displayed here can also be viewed at a transcript level in the ",
                          a("Lung Cell Transcriptome Explorer.", href="http://himeslab.org/asthmagenes/", target="_blank"),
                          " REALGAR facilitates prioritization and experiment design, ", "
                          elucidating the role of variants in complex disease",
                          " and leading to clinically actionable insights."), br(),
                        
                        navbarPage( "", 
                                   tabPanel("Results", 
                            wellPanel(fluidRow(align = "left",
                                           column(12,  
                                                  
                                                  fluidRow(h4(strong("Select options:")),align = "left"), 
                                                  fluidRow(div(style="margin-right: 25px", 
                                                               column(5, fluidRow(checkboxGroupInput(inputId="Tissue", label="Tissue", choices=c("Airway smooth muscle"="ASM", "Bronchial epithelium"="BE", 
                                                                                                                                             "Bronchoalveolar lavage"="BAL", "CD4"="CD4", "CD8"="CD8",
                                                                                                                                             "Lens epithelium" = "LEC","Lymphoblastic leukemia cell" = "chALL", 
                                                                                                                                             "Lymphoblastoid cell" = "LCL","Macrophage" = "MACRO", "MCF10A-Myc" = "MCF10A-Myc",
                                                                                                                                             "Nasal epithelium"="NE","Osteosarcoma U2OS cell" = "U2O", 
                                                                                                                                             "Peripheral blood mononuclear cell"="PBMC","Small airway epithelium"="SAE",
                                                                                                                                             "White blood cell"="WBC","Whole lung"="Lung"),selected="BE", inline = TRUE), align="left"),
                                                                      fluidRow(actionButton("selectall_tissue","Select all"))),
                                                                      column(2, fluidRow(checkboxGroupInput(inputId="Asthma", label="Asthma Type", choices=c("Allergic asthma"="allergic_asthma", "Asthma"="asthma", "Asthma and rhinitis"="asthma_and_rhinitis",
                                                                                                                                                 "Fatal asthma"="fatal_asthma", "Mild asthma"="mild_asthma", "Non-allergic asthma"="non_allergic_asthma",
                                                                                                                                                 "Severe asthma"="severe_asthma"), selected="asthma"), inline = TRUE),
                                                                 fluidRow(actionButton("selectall_asthma","Select all")), align="left"),
                                                  column(3, fluidRow(checkboxGroupInput(inputId="Treatment", label="Treatment", 
                                                                                   choices = c("Beta-agonist treatment"="BA", "Glucocorticoid treatment" = "GC", "Smoking"="smoking", "Vitamin D treatment"="vitD"), selected="")),
                                                                     fluidRow(actionButton("selectall_treatment","Select all")),
                                                         fluidRow(br(), textInput(inputId="curr_gene",label="Official gene symbol or SNP ID:", value= "GAPDH"),
                                                                  tags$head(tags$style(type="text/css", "#curr_gene {width: 190px}"))), 
                                                         align="left"),
                                                  column(2,
                                                         fluidRow(checkboxGroupInput(inputId="which_SNPs", label="GWAS Results", choices=c("GABRIEL"="snp_gabriel_subs", "GRASP"="snp_subs", "EVE"="snp_eve_subs"), selected=c("snp_subs"))),
                                                         fluidRow(uiOutput("eve_options"), conditionalPanel(condition = "output.eve_options=='GWAS display options:'", 
                                                                                                               selectInput("which_eve_pvals", "Which EVE p-values to use?", 
                                                                                                                           list("All subjects"="meta_P", "African American"="meta_P_AA", "European American"="meta_P_EA", "Latino"="meta_P_LAT"), 
                                                                                                                           selected="meta_P"))), align="left")),
                                                  hr()), 
                                           fluidRow(column(12, h4(strong("Data download:")),align = "left")),
                                           fluidRow(column(12, h5("The results displayed in the forest plots and gene tracks below may also be downloaded directly here:"))), br(),
                                           fluidRow(column(6, downloadButton(outputId="table_download", label="Download fold change and p-value results displayed in forest plots below"), align="left"),
                                                    column(6, downloadButton(outputId="SNP_data_download", label="Download GWAS results displayed in gene tracks below"), align="left")))),

                        mainPanel(hr(),
                                  fluidRow(br(),
                                           column(10, plotOutput(outputId="forestplot_asthma",width="935px", height="650px"), align="left"), 
                                           div(style="margin-top: 45px", column(2, imageOutput("color_scale1"), align="right")), # margin-top needed to align color scale w/ forest plot
                                           column(12, downloadButton(outputId="asthma_fc_download",label="Download asthma forest plot"), align="center"), 
                                           column(10, conditionalPanel(condition = "input.Treatment != ''", br(), br(), plotOutput(outputId="forestplot_GC",width="935px", height="650px")),align="left"),
                                           column(2, div(style="margin-top: 80px", conditionalPanel(condition = "input.Treatment != ''", imageOutput("color_scale2")), align="right")), # margin-top needed to align color scale w/ forest plot
                                           column(12, conditionalPanel(condition = "input.Treatment != ''", downloadButton(outputId="GC_fc_download",label="Download GC forest plot")), align="center"),
                                           column(12, conditionalPanel(condition = "input.Treatment != ''", h5("Alb=Albuterol; Dex=Dexamethasone")), align="right")), br(), hr(), width = 12,
                                  
                                  fluidRow(column(12, p("Transcripts for the selected gene are displayed here. ",
                                                        "Any SNPs and/or GR binding sites that fall within the gene ",
                                                        "or within +/- 10kb of the gene are also displayed, ",
                                                        "each in a separate track. GR binding sites are colored by the ",
                                                        "ENCODE binding score (shown below each binding site), ",
                                                        "with the highest binding scores corresponding to the brightest colors. ",
                                                        "Only those SNPs with p-value <= 0.05 are included. ",
                                                        "SNPs are colored by p-value, with the lowest p-values corresponding to the brightest colors. ",
                                                        "All SNP p-values are obtained directly from the study in which the association was published.")),
                                           column(12, downloadButton(outputId="gene_tracks_download", label="Download gene tracks"), align="center"), br(),
                                           column(12, HTML("<div style='height: 102px;'>"), imageOutput("color_scale3"), align="left", HTML("</div>")),
                                           column(12, align="left", plotOutput(outputId="gene_tracks_outp2")),
                                           # div(style="margin-top: 150px", column(2, imageOutput("color_scale3"), align="right")), 
                                           br(), br())))),
                        tabPanel("Datasets loaded",
                                 column(12,align="left",
                                        fluidRow(h4("Datasets loaded:")),
                                        fluidRow(p("Click on links to access the datasets and studies referenced in the table.")),
                                        fluidRow(DT::dataTableOutput(outputId="GEO_table"), br()),
                                        fluidRow(img(src="http://shiny.rstudio.com/tutorial/lesson2/www/bigorb.png", height=35, width=38), 
                                                 "Created with RStudio's ", a("Shiny", href="http://www.rstudio.com/shiny", target="_blank")))))))
