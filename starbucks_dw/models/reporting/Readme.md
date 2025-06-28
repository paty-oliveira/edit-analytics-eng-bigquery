# Projeto: Starbucks Customer Analytics

Este mini-projeto tem como objetivo complementar o projeto DBT com uma camada **reporting** para responder perguntas de negócio com foco em análise e BI.

## Objetivos de Negócio

1. **Segmentação e Responsividade dos Clientes**
   Identificar quais segmentos de clientes (por idade, gênero, comportamento) são mais propensos a responder a promoções.

2. **Efetividade dos Canais**
   Avaliar qual canal (email ou mobile) gera maior taxa de resposta.

## Estrutura Implementada

Os modelos foram organizados dentro da pasta `models/reporting`, com os seguintes arquivos principais:

- `rpt_customer_segmentation.sql`: analisa o perfil dos clientes e sua taxa de resposta.
- `rpt_channel_effectiveness.sql`: compara os canais de promoção quanto à performance.

Além disso, foram implementadas **macros reutilizáveis** na pasta `macros`, incluindo:
- `calc_response_rate`: cálculo seguro da taxa de conversão
- `age_group_case`: macro parametrizável para categorizar idades em faixas

## Materialização como TABLE

Optamos por **materializar os modelos reporting como `table`** em vez de `view`, com base nos seguintes motivos:

- **Desempenho**: Tabelas materializadas garantem consultas mais rápidas para dashboards e ferramentas de BI.
- **Economia de custos**: Em BigQuery, views são reprocessadas a cada leitura, o que pode gerar alto custo. Tabelas evitam esse retrabalho.
- **Integração com BI**: Ferramentas como Power BI, Superset e Looker trabalham melhor com tabelas persistidas.
- **Estabilidade analítica**: Garante que os dados estejam prontos e consistentes no momento da análise, mesmo com grandes volumes e joins.
