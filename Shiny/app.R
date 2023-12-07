# Bibliotecas 
library(shiny)         # Para criar aplicativos web interativos
library(shinythemes)   # Para adicionar temas visuais ao aplicativo
library(ggplot2)       # Para criação de gráficos
library(dplyr)         # Para manipulação de dados
library(tidyr)         # Para organização de dados
library(scales)        # Para formatação de gráficos

# Carregar os dados de faixa etária e sexo de vacinação monovalente e bivalente
dados_faixa_etaria_mono <- read.csv("../Tabelas .csv/faixa_etaria_monovalentebtu.csv", sep = ";")
dados_faixa_etaria_bi <- read.csv("../Tabelas .csv/faixa_etaria_bivalentebtu.csv", sep = ";")
dados_sexo_mono <- read.csv("../Tabelas .csv/sexo_monovalentebtu.csv", sep = ";")
dados_sexo_bi <- read.csv("../Tabelas .csv/sexo_bivalentebtu.csv", sep = ";")

# Interface do usuário (UI)
ui <- tagList(
  
  # Estilização do título
  tags$style(HTML("
    .titulo {
      font-family: 'Arial'; /* Fonte */
      font-size: 28px;                  /* Define o tamanho da fonte como 28 pixels */
      color: #333;                      /* Define a cor do texto como um tom escuro (#333) */
      margin-bottom: 15px;              /* Adiciona margem abaixo do título */
      border-bottom: 6px solid #5680EA; /* Adiciona uma linha na parte inferior do título */
      padding-bottom: 10px;             /* Adiciona um pequeno espaçamento abaixo da linha */
      text-align: center;               /* Centraliza o texto */
    }
  ")),
  tags$h2(class = "titulo", "Vacinômetro de Botucatu"), # Título do app
  
  navbarPage(
    theme = shinytheme("readable"), # Definindo o tema
    "shinythemes",
    
    # Aba: Dose por estabelecimento de saude
    tabPanel("Tipo de Dose por Estabelecimento de Saúde",
             sidebarPanel( # Painel lateral esquerdo para inputs e controles
                          fileInput("arquivo_dose", label = "Selecione seu arquivo"), # Input de arquivo para carregar dados
                          checkboxGroupInput("Dose", "Selecione o Tipo de Dose:", choices = NULL), # Checkbox para seleção do tipo de dose
                          width = 2), # Define a largura da barra lateral
             
             mainPanel( # Painel principal para a saída de gráfico
               plotOutput("plot_dose", height = "800px", width = 1550) # Define a área para renderizar o gráfico
               )
    ),
    
    # Aba: Dose por faixa etaria
    tabPanel("Tipo de Dose por Faixa Etária",
             sidebarPanel( # Painel lateral esquerdo para inputs e controles
                          radioButtons("arquivo_faixa_etaria", "Selecione o conjunto de dados:", # Botões para seleção do tipo de conjunto de dados
                                        choices = c("Monovalente", "Bivalente"), # Opções para seleção
                                        selected = "Monovalente"), # Seleção padrão
                          width = 2), # Define a largura da barra lateral
             mainPanel( # Painel principal para a saída de gráfico
               plotOutput("plot_faixa_etaria", height = "800px", width = 1550) # Define a área para renderizar o gráfico
               )
    ),
    
    # Aba: Dose por sexo
    tabPanel("Tipo de Dose por Sexo",
             sidebarPanel( # Painel lateral esquerdo para inputs e controles
                          radioButtons("arquivo_sexo", "Selecione o conjunto de dados:", # Botões para seleção do tipo de conjunto de dados
                                      choices = c("Monovalente", "Bivalente"), # Opções para seleção
                                      selected = "Monovalente"), # Seleção padrão
                          width = 2), # Define a largura da barra lateral
             mainPanel( # Painel principal para a saída de gráfico
               plotOutput("plot_sexo", height = "800px", width = 1550) # Define a área para renderizar o gráfico
               )
    )
  )
)

# Servidor
server <- function(input, output, session) {
  
  # Dose por estabelecimento de saude ------------------------------------------------------
  observeEvent(input$arquivo_dose, { # Observa a mudança no arquivo de entrada para a seção de doses
    dados <<- read.csv(input$arquivo_dose$datapath, sep = ";", stringsAsFactors = FALSE) # Carrega os dados do arquivo selecionado
    display_choices <- sort(gsub("\\.", " ", names(dados)[grep("[Dd]ose", names(dados))])) # Criar lista com nomes para exibição na caixa de seleção (substituir pontos por espaços)
    updateCheckboxGroupInput(session, "Dose", choices = display_choices) # Atualiza as opções da checkbox de seleção para os tipos de doses disponíveis
  })
  
  # Renderizando o gráfico para a aba de dose por estabelecimento de saúde
  output$plot_dose <- renderPlot({
    # Verificando se 'dados' e 'input$Dose' estão presentes e não são nulos
    req(dados)
    req(input$Dose)
    
    # Revertendo os nomes dos tipos de doses selecionados para seus valores originais com pontos
    selected_cols <- gsub(" ", ".", input$Dose) 
    
    # Filtra os dados selecionados para o gráfico
    filtered_data <- dados %>%
      select(estabelecimento, all_of(selected_cols))
    
    # Reorganiza os dados para facilitar a plotagem do gráfico
    dados_plot_dose <- tidyr::gather(filtered_data, key = "Dose", value = "count", -estabelecimento)
    
    # Cria o gráfico de barras
    ggplot(dados_plot_dose, aes(x = reorder(estabelecimento, -count), y = count, fill = Dose)) +
      geom_bar(stat = "identity", position = "dodge") + # Definindo o tipo de gráfico como barras 
      # stat = "identity": Utiliza os valores dos dados para a altura das barras
      # position = "dodge": Empilha as barras lado a lado
      
      geom_text(aes(label = count), vjust = -0.5, position = position_dodge(width = 0.9), size = 3, color = "black", show.legend = FALSE) + # Adicionando rótulos nas barras
      # aes(label = count): Utiliza os valores da variável 'count' para os rótulos
      # vjust = -0.5: Ajusta a posição vertical dos rótulos
      # position = position_dodge(width = 0.9): Alinha os rótulos com a posição das barras
      # size = 3: Define o tamanho dos rótulos
      # color = "black": Define a cor do texto
      # show.legend = FALSE: Não mostra esse elemento na legenda do gráfico
      
      labs(title = "Contagem de doses por estabelecimento de saúde", x = "Estabelecimento de saúde", y = "Total de Doses Aplicadas", fill = "") + # Definindo os rótulos para título, eixos x e y e a legenda
      # title: Define o título do gráfico
      # x e y: Define os rótulos dos eixos x e y
      # fill = "": Remove o título da legenda de cores do gráfico
      
      guides(fill = guide_legend(title = NULL)) + # Definindo guias do gráfico
      # fill = guide_legend(title = NULL): Remove o título da legenda de cores
      
      scale_fill_discrete(labels = function(x) gsub("\\.", " ", x)) + # Modifica a escala de cores no gráfico
      # labels = function(x) gsub("\\.", " ", x): Remove pontos nos rótulos da legenda
      
      theme_minimal() + # Aplica um tema mínimo ao gráfico
      theme(legend.position = "top", # Posiciona a legenda no topo
            axis.text.x = element_text(angle = 50, hjust = 1, size = 10), # Ajusta o ângulo, alinhamento e tamanho do texto no eixo x
            axis.text.y = element_text(size = 12, margin = margin(r = 50)), # Define o tamanho do texto e margem do eixo y
            axis.title = element_text(size = 15), # Define o tamanho do texto dos títulos dos eixos
            legend.text = element_text(size = 12), # Define o tamanho do texto na legenda
            plot.title = element_text(size = 18)) + # Define o tamanho do título do gráfico
      scale_y_continuous(labels = label_number()) # Define o formato dos rótulos no eixo y
  })
  
  
  # Dose por faixa etaria ------------------------------------------------------
  dados_faixa_etaria <- reactive({ # Define uma função reativa que é acionada sempre que input$arquivo_faixa_etaria é alterado
    
    if (input$arquivo_faixa_etaria == "Monovalente") { # Verifica se a seleção do usuário é "Monovalente"
      return(dados_faixa_etaria_mono) # Retorna os dados correspondentes a "Monovalente"
    } else {
      return(dados_faixa_etaria_bi) # Retorna os dados correspondentes a "Bivalente"
    }
    
  })
  
  # Renderizando o gráfico para a aba de dose por faixa etaria
  output$plot_faixa_etaria <- renderPlot({
    # Verificando se 'dados_faixa_etaria()' existe e não é nulo
    req(dados_faixa_etaria())
    
    # Ordenar os dados por 'faixa_etaria'
    dados_ordenados <- dados_faixa_etaria()
    dados_ordenados$faixa_etaria <- factor(dados_ordenados$faixa_etaria, levels = unique(dados_ordenados$faixa_etaria))
    dados_ordenados <- dados_ordenados[order(dados_ordenados$faixa_etaria), ] # Organiza os dados por 'faixa_etaria' para garantir a correta disposição no eixo x
    
    # Criar o gráfico de barras ordenado por 'faixa_etaria'
    ggplot(dados_ordenados, aes(x = faixa_etaria, y = total_de_doses_aplicadas, fill = total_de_doses_aplicadas)) +
      geom_bar(stat = "identity") + # Definindo o tipo de gráfico como barras
      geom_text(aes(label = total_de_doses_aplicadas), vjust = -0.5, position = position_dodge(width = 0.9), size = 5, color = "black", show.legend = FALSE) + # Adicionando rótulos nas barras
      labs(title = "Total de Doses Aplicadas por Faixa Etária", x = "Faixa Etária", y = "Total de Doses Aplicadas", fill = "Total de doses aplicadas") + # Definindo os rótulos para título, eixos x e y e a legenda
      scale_fill_gradient(low = "lightblue", high = "#5680EA") +  # Definindo a escala de cores
      theme_minimal() + # Aplica um tema mínimo ao gráfico
      theme(axis.text.x = element_text(angle = 50, hjust = 1), # Ajustando o ângulo e o alinhamento do texto no eixo x
            axis.text = element_text(size = 12), # Define o tamanho do texto do eixo x e y
            axis.title = element_text(size = 15), # Define o tamanho do texto dos títulos dos eixos
            legend.title = element_text(size = 12), # Define o tamanho do texto do título da legenda
            legend.text = element_text(size = 12), # Define o tamanho do texto da legenda
            plot.title = element_text(size = 18)) + # Define o tamanho do título do gráfico
      scale_y_continuous(labels = label_number()) # Define o formato dos rótulos no eixo y
  })
  
  # Dose por Sexo ------------------------------------------------------
  dados_sexo <- reactive({ # Define uma função reativa que é acionada sempre que input$arquivo_sexo é alterado
    if (input$arquivo_sexo == "Monovalente") { # Verifica se a seleção do usuário é "Monovalente"
      return(dados_sexo_mono)  # Retorna os dados de sexo correspondentes a "Monovalente"
    } else {
      return(dados_sexo_bi) # Retorna os dados de sexo correspondentes a "Bivalente"
    }
  })
  
  # Renderizando o gráfico para a aba de dose por sexo
  output$plot_sexo <- renderPlot({
    # Verifica se 'dados_sexo()' existe e não é nulo
    req(dados_sexo())
    
    # Ordenar os dados por 'sexo'
    dados_ordenados <- dados_sexo()
    dados_ordenados$sexo <- factor(dados_ordenados$sexo, levels = unique(dados_ordenados$sexo))
    dados_ordenados <- dados_ordenados[order(dados_ordenados$sexo), ] # Organiza os dados por 'sexo' para garantir a correta disposição no eixo x
    
    # Criar o gráfico de barras ordenado por 'sexo'
    ggplot(dados_ordenados, aes(x = sexo, y = total_de_doses_aplicadas)) +
      geom_bar(stat = "identity", fill = "#5680EA") + # Definindo o tipo de gráfico como barras e a cor das barras
      geom_text(aes(label = total_de_doses_aplicadas), vjust = -0.5, position = position_dodge(width = 0.9), size = 5, color = "black", show.legend = FALSE) + # Adicionando rótulos nas barras
      labs(title = "Total de Doses Aplicadas por Sexo", x = "Sexo", y = "Total de Doses Aplicadas") + # Definindo os rótulos para título, eixos x e y e a legenda
      theme_minimal() + # Aplica um tema mínimo ao gráfico
      theme(axis.text.x = element_text(angle = 50, hjust = 1), # Ajustando o ângulo e o alinhamento do texto no eixo x
            axis.text = element_text(size = 12), # Define o tamanho do texto do eixo x e y
            axis.title = element_text(size = 15), # Define o tamanho do texto dos títulos dos eixos
            plot.title = element_text(size = 18)) + # Define o tamanho do título do gráfico
      scale_y_continuous(labels = label_number()) # Define o formato dos rótulos no eixo y
  })
  
}

# Criar o aplicativo Shiny
shinyApp(ui = ui, server = server)
