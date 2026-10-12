# Star Vip Academia

Site institucional multipágina da **Star Vip Academia** — musculação e aulas coletivas em **Brazlândia/DF** (Vila São José, Quadra 47, Conj. G, Lote 05).

Páginas em português, construídas com HTML, CSS e JavaScript puros — sem dependências, sem etapa de build.

## Modo demonstração (versão atual)

Este é um **exemplo para apresentação ao cliente**:

- **Telefone/WhatsApp** usam o placeholder `(00) 00000-0000` — em links `wa.me/5500000000000`, `tel:+5500000000000` e nos textos. Os links de WhatsApp abrem com a mensagem pronta, mas o número não é real.
- Todas as páginas exibem uma **faixa "Demonstração"** no topo avisando que os dados definitivos só serão publicados com autorização do cliente (dispensável pelo botão ✕; a escolha fica em `localStorage`).
- **E-mail, endereço, horários, modalidades e parceiros** permanecem com os dados reais das fontes públicas, pois já são informações de domínio público da academia.

Para publicar de verdade, troque o placeholder pelo número oficial (seção [Configurar antes de publicar](#configurar-antes-de-publicar)) e remova a faixa `.demo-bar` dos HTML + o bloco `0. Faixa de demonstração` do `js/main.js` + o CSS `.demo-bar`.

## Estrutura

```
star-vip-academia/
├── index.html          # Início: hero, diferenciais, modalidades, planos, estrutura
├── academia.html       # Apresentação, horários e parceiros
├── modalidades.html    # Musculação, funcional, pilates, jump e fit dance
├── planos.html         # Consulta de planos (sem preços publicados)
├── estrutura.html      # Galeria com lightbox, comodidades e rota
├── contato.html        # Canais, formulário validado e mapa
├── privacidade.html    # Política de privacidade (formulário e dados)
├── css/styles.css      # Identidade visual e layout responsivo
├── js/main.js          # Menu mobile, validação, lightbox e animações
├── img/                # Logo, fotos, favicon e imagem social
├── img/_orig/          # Originais baixados do Instagram (fonte das fotos)
├── build-img.ps1       # Pipeline reproduzível de recorte das imagens
├── docs/PRD.md         # Documento de requisitos do projeto
├── server.ps1          # Servidor local para Windows (PowerShell)
└── README.md
```

## Identidade visual

Extraída dos flyers oficiais da própria academia (paleta, tipografia e grafismos), seguindo o PRD:

| Cor | Hex | Uso |
|-----|-----|-----|
| Preto carvão | `#101114` | Fundo principal |
| Carvão claro | `#17181C` / `#24262C` | Cartões e bordas |
| Vermelho (grafismo) | `#E01B23` | Faixas, diagonais e detalhes |
| Vermelho (botões) | `#C81E24` | Fundo de botões com texto branco (contraste AA) |
| Vermelho (texto) | `#FF4D4D` | Links e destaques sobre fundo escuro (AA) |
| Branco | `#F7F7F8` | Títulos e texto principal |
| Cinza | `#B9BDC4` | Texto secundário |

**Tipografia:** [Anton](https://fonts.google.com/specimen/Anton) (títulos condensados em caixa alta), [Barlow](https://fonts.google.com/specimen/Barlow) (corpo e botões) e [Kaushan Script](https://fonts.google.com/specimen/Kaushan+Script) (acentos manuscritos ocasionais), via Google Fonts.

Grafismos: diagonais vermelhas no hero e nas páginas internas + tarja `////` inspirada no logotipo. O **logotipo oficial** foi extraído em alta resolução de um flyer da própria academia e teve o fundo recortado para transparência — não é uma recriação em texto.

## Rodar localmente

```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1
# http://localhost:8757
```

Outras opções:

```bash
# Python
python -m http.server 8000

# Node
npx serve .
```

## Dados usados e fontes

Todos os dados vêm de fontes oficiais da academia; nada foi inventado.

| Dado | Valor | Fonte |
|------|-------|-------|
| WhatsApp / telefone | (61) 99818-9357 | Bio do Instagram, site institucional antigo |
| E-mail | acdstarvip@gmail.com | Site institucional antigo |
| Endereço | Quadra 47, Conj. G, Lote 05 (SGO Q 1 Ae, 01) — Vila São José, Brazlândia/DF, 72747-007 | Ficha do Google Meu Negócio + destaque "Localização" do Instagram + CNPJ |
| Horários | Seg a sex 6h–22h30 · Sáb 7h–18h · Dom 8h–13h | Destaque "HORÁRIOS" do Instagram |
| Modalidades | Musculação, Funcional, Pilates, Jump, Fit Dance | Destaques e posts oficiais do Instagram |
| Parceiros | Wellhub a partir do plano Basic · TotalPass a partir do TP1 | Destaque "PARCEIROS" do Instagram |
| Instagram | @academiastarvip | Perfil oficial |
| Facebook | /academiastarvip | Página oficial |
| CNPJ | 27.390.051/0001-23 (STAR VIP ACADEMIA LTDA) | Consulta pública de cadastro |
| Fotos e logo | Posts e flyers oficiais da academia | Instagram (CDN oficial), recortados com `build-img.ps1` |

Rota: link `Google Maps Directions` com o endereço acima; mapa incorporado nas páginas de estrutura e contato.

## Configurar antes de publicar

Busque e substitua nos HTML/JS, caso algum dado mude:

| Onde | Valor atual (demonstração) | Trocar por |
|------|----------------------------|------------|
| Número no WhatsApp (`wa.me/`) | `5500000000000` (placeholder) | `55` + DDD + número oficial (ex.: `5561998189357`) |
| Telefone (`tel:`) | `+5500000000000` (placeholder) | Telefone oficial (ex.: `+5561998189357`) |
| Texto do telefone | `(00) 00000-0000` (placeholder) | `(61) 99818-9357` |
| E-mail | `acdstarvip@gmail.com` | E-mail oficial |
| Horários e endereço | conforme tabela acima | Confirmar com a academia |
| Instagram / Facebook | `academiastarvip` | Perfis oficiais confirmados |
| Mapa | busca por endereço no `output=embed` | ID do Google Meu Negócio, se houver |
| Faixa "Demonstração" | presente em todas as páginas | Remover o bloco `.demo-bar` dos HTML, do CSS e do JS ao publicar |

**Importante:** as fotos vêm dos canais oficiais da própria academia e precisam de **autorização de uso** antes da publicação. Se a academia enviar fotos e o logo em arquivo original, basta substituir os arquivos em `img/` — os nomes já estão padronizados (`logo.png`, `favicon.png`, `fachada.jpg`, `logo-parede.jpg`, `vestiario.jpg`, `teto-led.jpg`, `halteres.jpg`, `og-image.jpg`).

### Pendências de conteúdo (aguardando confirmação da academia)

- **Preços e planos:** não existem valores publicados em nenhuma fonte oficial — a página `planos.html` usa a chamada "Consultar planos" e a equipe envia as opções. Inserir cards com preços somente quando enviados e aprovados.
- **Grade de aulas:** horários das aulas coletivas não são públicos; os cards convidam a pedir a grade.
- **Depoimentos:** nenhum aluno autorizou uso de avaliação — seção omitida por decisão do PRD.
- **Acessibilidade e estacionamento:** informação não publicada; a página de estrutura deixa a dúvida explícita para a equipe.
- **Formulário:** a validação acontece no navegador e a mensagem é entregue via WhatsApp (não há backend). Se no futuro quiser e-mail, ligar um serviço como Formspree/Netlify Forms.

## Publicar

O site é 100% estático — qualquer hospedagem funciona:

- **GitHub Pages:** *Settings → Pages → Deploy from a branch → main*
- **Vercel / Netlify:** importar o repositório, build vazio, public directory `/`
- **Domínio próprio:** apontar o CNAME após a configuração na hospedagem

## Acessibilidade e SEO

- Contraste AA: botões vermelhos em `#C81E24` com texto branco; links em `#FF4D4D` sobre fundo escuro
- `lang="pt-BR"`, título e meta description únicos por página, Open Graph com `og-image.jpg` (1200×630)
- Schema `HealthClub` no início com endereço, horários, telefone e redes
- Menu compacto com `aria-expanded`, link “Pular para o conteúdo”, foco visível
- Alvos de toque ≥ 44px; textos alternativos descritivos em todas as fotos
- Animação de entrada discreta com fallback de 2,5 s e `prefers-reduced-motion`
- Galeria com lightbox acessível (teclado: Enter, Esc, setas)
- Formulário com validação campo a campo, mensagens de erro e confirmação de envio
- Imagens com `loading="lazy"` e dimensões declaradas
- Eventos `data-track` prontos para GTM/dataLayer (WhatsApp, planos, rota, formulário)

## Roadmap (fase 2)

- Fotos oficiais em alta resolução enviadas pela academia
- Cards de planos assim que houver valores aprovados
- Grade de aulas com horários confirmados
- Google Meu Negócio com link para o site
- Integração com Google Analytics/GTM (os botões já emitem eventos)

---

Documento de requisitos completo em [`docs/PRD.md`](docs/PRD.md).
