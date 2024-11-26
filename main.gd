extends Control

# Dados
var nomes_produtos = [] # nomes_produtos[indice_nome_produto] -> string
var tags_produtos = [] # tags_produtos[indice_produto][indice_tag] -> string
var cor_lojas_produtos = [] # cor_lojas_produtos[indice_produto][indice_cor_loja] -> array(R, G, B, A)
var url_lojas_produtos = [] # url_lojas_produtos[indice_produto][indice_url_loja] -> string
var data_lojas_produtos = [] # data_lojas_produtos[indice_produto][indice_data_preco] -> object{"year", "month", "day", "weekday"}
var preco_lojas_produtos = [] # preco_lojas_produtos[indice_produto][indice_loja][indice_preco_data] -> float

# Janela Inicial
var ControlJanelaInicial = Control.new()
var LineEditFiltrarProdutoPorNome = LineEdit.new()
var LabelFiltrarProdutosPorTags = Label.new()
var ScrollContainerFiltrarProdutosPorTags = ScrollContainer.new()
var HBoxContainerFiltrarProdutosPorTags = HBoxContainer.new()
var LabelSettingsPrecoMedio = LabelSettings.new()
var ScrollContainerProdutos = ScrollContainer.new()
var VBoxContainerProdutos = VBoxContainer.new()
var ButtonSobreOPrograma = Button.new()
var ButtonAdicionarProduto = Button.new()
var ConfirmationDialogRemoverProduto = ConfirmationDialog.new()
var AcceptDialogSobreOPrograma = AcceptDialog.new()

# Janela Adicao e Edicao
var ControlJanelaAdicaoEdicao = Control.new()
var LineEditNomeDoProduto = LineEdit.new()
var LineEditTagsDoProduto = LineEdit.new()
var ScrollContainerURLECorDasLojas = ScrollContainer.new()
var VBoxContainerURLECorDasLojas = VBoxContainer.new()
var ButtonAdicionarLoja = Button.new()
var ButtonCancelarAdicaoOuEdicao = Button.new()
var ButtonConfirmarAdicaoOuEdicao = Button.new()
var ConfirmationDialogRemoverLoja = ConfirmationDialog.new()
var AcceptDialogErrosDaAdicaoOuEdicao = AcceptDialog.new()

# Janela Produto
var ControlJanelaProduto = Control.new()
var LabelNomeDoProduto = Label.new()
var LabelTagsDoProduto = Label.new()
var OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos = OptionButton.new()
var ScrollContainerIncluirPrecosAtuaisPorLoja = ScrollContainer.new()
var VBoxContainerIncluirPrecosAtuaisPorLoja = VBoxContainer.new()
var ButtonIncluirPrecosAtuais = Button.new()
var OptionButtonGraficoDoHistoricoDePrecosPorPeriodo = OptionButton.new()
var ScrollContainerGraficoDoHistoricoDePrecos = ScrollContainer.new()
var VBoxContainerGraficoDoHistoricoDePrecos = VBoxContainer.new()
var ButtonVoltarParaJanelaInicial = Button.new()
var ButtonEditarDadosDoProduto = Button.new()
var AcceptDialogErrosDeIncluirPrecosAtuais = AcceptDialog.new()

# Funcoes Gerais
func _ready():
	carregarDados()
	propriedadesInterface()
	filtrarProdutosPorNomeETags()

func propriedadesInterface():
	'''
	Define as propriedades dos elementos fixos os dinamicos sao definidos no 
	momento que sao criados.
	Crie a funcao para ser separado de func _ready(): para o codigo ser mais
	legivel e simples de testar e modificar.
	'''
	
	# Control Geral
	custom_minimum_size = Vector2(640, 360)
	layout_direction = Control.LAYOUT_DIRECTION_LTR
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Window Geral
	get_window().title = 'Monitor de Preços Manual'
	get_window().size = Vector2(960, 540)
	get_window().min_size = Vector2(640, 360)
	get_window().max_size = Vector2(32000, 18000)
	get_window().disable_3d = true
	get_window().positional_shadow_atlas_size = 0
	get_window().positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	get_window().positional_shadow_atlas_quad_1 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	get_window().positional_shadow_atlas_quad_2 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	get_window().positional_shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	get_window().process_mode = Node.PROCESS_MODE_ALWAYS
	get_window().connect('size_changed', Callable(self, 'redimensionamentoInterface'))
	get_window().connect('close_requested', Callable(self, 'salvarDados'))
	
	# Janela Inicial
	ControlJanelaInicial.custom_minimum_size = Vector2(640, 360)
	ControlJanelaInicial.connect('visibility_changed', Callable(self, 'redimensionamentoInterface'))
	add_child(ControlJanelaInicial)
	
	LineEditFiltrarProdutoPorNome.placeholder_text = 'Filtrar Produtos por Nome'
	LineEditFiltrarProdutoPorNome.clear_button_enabled = true
	LineEditFiltrarProdutoPorNome.custom_minimum_size = Vector2(600, 40)
	LineEditFiltrarProdutoPorNome.tooltip_text = 'Escreva o Nome exato do(s) Produto(s) que esteja buscando.\nVocê não consegue escrever um Nome não registrado.'
	LineEditFiltrarProdutoPorNome.set_meta('ultimo_nome_filtrado', '')
	LineEditFiltrarProdutoPorNome.connect('text_changed', Callable(self, 'filtrarProdutosPorNomeETags'))
	ControlJanelaInicial.add_child(LineEditFiltrarProdutoPorNome)
	
	LabelFiltrarProdutosPorTags.text = 'Tags: '
	LabelFiltrarProdutosPorTags.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	LabelFiltrarProdutosPorTags.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	LabelFiltrarProdutosPorTags.clip_text = true
	LabelFiltrarProdutosPorTags.custom_minimum_size = Vector2(50, 31)
	LabelFiltrarProdutosPorTags.tooltip_text = 'Selecione quais Tags os Produtos precisam conter em si.\nApenas Produtos que contenham todas as Tags selecionadas serão exibidos.'
	ControlJanelaInicial.add_child(LabelFiltrarProdutosPorTags)
	
	ScrollContainerFiltrarProdutosPorTags.follow_focus = true
	ScrollContainerFiltrarProdutosPorTags.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ScrollContainerFiltrarProdutosPorTags.custom_minimum_size = Vector2(550, 40)
	ControlJanelaInicial.add_child(ScrollContainerFiltrarProdutosPorTags)
	
	HBoxContainerFiltrarProdutosPorTags.custom_minimum_size = Vector2(550, 31)
	HBoxContainerFiltrarProdutosPorTags.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	HBoxContainerFiltrarProdutosPorTags.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ScrollContainerFiltrarProdutosPorTags.add_child(HBoxContainerFiltrarProdutosPorTags)
	
	LabelSettingsPrecoMedio.font_size = 32
	LabelSettingsPrecoMedio.font_color = Color(0.3137, 0.7843, 0.4706, 1)
	LabelSettingsPrecoMedio.outline_size = 8
	LabelSettingsPrecoMedio.outline_color = Color(0, 0.2392, 0.149, 1)
	LabelSettingsPrecoMedio.shadow_size = 0
	LabelSettingsPrecoMedio.shadow_color = Color(0, 0, 0, 0)
	LabelSettingsPrecoMedio.shadow_offset = Vector2(0, 0)
	
	ScrollContainerProdutos.follow_focus = true
	ScrollContainerProdutos.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ScrollContainerProdutos.custom_minimum_size = Vector2(600, 140)
	ControlJanelaInicial.add_child(ScrollContainerProdutos)
	
	VBoxContainerProdutos.custom_minimum_size = Vector2(600, 140)
	VBoxContainerProdutos.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	VBoxContainerProdutos.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ScrollContainerProdutos.add_child(VBoxContainerProdutos)
	
	ButtonSobreOPrograma.text = 'Sobre o Programa'
	ButtonSobreOPrograma.custom_minimum_size = Vector2(290, 40)
	ButtonSobreOPrograma.tooltip_text = 'Informações sobre o Programa.'
	ButtonSobreOPrograma.connect('pressed',Callable(self,'sobrePrograma'))
	ControlJanelaInicial.add_child(ButtonSobreOPrograma)
	
	ButtonAdicionarProduto.text = 'Adicionar Produto'
	ButtonAdicionarProduto.custom_minimum_size = Vector2(290, 40)
	ButtonAdicionarProduto.tooltip_text = 'Clique para Adicionar um Produto.'
	ButtonAdicionarProduto.connect('pressed', Callable(self, 'possivelmenteAdicionarProduto'))
	ControlJanelaInicial.add_child(ButtonAdicionarProduto)
	
	ConfirmationDialogRemoverProduto.cancel_button_text = 'Não'
	ConfirmationDialogRemoverProduto.ok_button_text = 'Sim'
	ConfirmationDialogRemoverProduto.dialog_autowrap = true
	ConfirmationDialogRemoverProduto.title = 'Remover Produto'
	ConfirmationDialogRemoverProduto.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	ConfirmationDialogRemoverProduto.unresizable = true
	ConfirmationDialogRemoverProduto.min_size = Vector2(160, 90)
	ConfirmationDialogRemoverProduto.max_size = Vector2(8000, 4500)
	ConfirmationDialogRemoverProduto.disable_3d = true
	ConfirmationDialogRemoverProduto.positional_shadow_atlas_size = 0
	ConfirmationDialogRemoverProduto.positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ConfirmationDialogRemoverProduto.positional_shadow_atlas_quad_1 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ConfirmationDialogRemoverProduto.positional_shadow_atlas_quad_2 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ConfirmationDialogRemoverProduto.positional_shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ControlJanelaInicial.add_child(ConfirmationDialogRemoverProduto)
	
	AcceptDialogSobreOPrograma.dialog_text = 'Este programa foi desenvolvido como um trabalho da UNICEP.'
	AcceptDialogSobreOPrograma.dialog_autowrap = true
	AcceptDialogSobreOPrograma.title = 'Sobre, Versão: 1.0'
	AcceptDialogSobreOPrograma.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	AcceptDialogSobreOPrograma.unresizable = true
	AcceptDialogSobreOPrograma.min_size = Vector2(160, 90)
	AcceptDialogSobreOPrograma.max_size = Vector2(8000, 4500)
	AcceptDialogSobreOPrograma.disable_3d = true
	AcceptDialogSobreOPrograma.positional_shadow_atlas_size = 0
	AcceptDialogSobreOPrograma.positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogSobreOPrograma.positional_shadow_atlas_quad_1 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogSobreOPrograma.positional_shadow_atlas_quad_2 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogSobreOPrograma.positional_shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ControlJanelaInicial.add_child(AcceptDialogSobreOPrograma)
	
	# Janela Adicao e Edicao
	ControlJanelaAdicaoEdicao.custom_minimum_size = Vector2(640, 360)
	ControlJanelaAdicaoEdicao.visible = false
	ControlJanelaAdicaoEdicao.connect('visibility_changed', Callable(self, 'redimensionamentoInterface'))
	add_child(ControlJanelaAdicaoEdicao)
	
	LineEditNomeDoProduto.placeholder_text = 'Nome do Produto'
	LineEditNomeDoProduto.custom_minimum_size = Vector2(600, 40)
	LineEditNomeDoProduto.tooltip_text = 'Escreva o Nome que o Produto terá.'
	ControlJanelaAdicaoEdicao.add_child(LineEditNomeDoProduto)
	
	LineEditTagsDoProduto.placeholder_text = 'Tags do Produto'
	LineEditTagsDoProduto.custom_minimum_size = Vector2(600, 40)
	LineEditTagsDoProduto.tooltip_text = 'Escreva as Tags que o Produto terá.\nCada Tag é separada com uma \",\".'
	ControlJanelaAdicaoEdicao.add_child(LineEditTagsDoProduto)
	
	ScrollContainerURLECorDasLojas.follow_focus = true
	ScrollContainerURLECorDasLojas.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ScrollContainerURLECorDasLojas.custom_minimum_size = Vector2(600, 80)
	ScrollContainerURLECorDasLojas.set_meta('janela_adicao', false)
	ScrollContainerURLECorDasLojas.set_meta('lista_lojas', [])
	ScrollContainerURLECorDasLojas.set_meta('remover_loja_antiga', [])
	ControlJanelaAdicaoEdicao.add_child(ScrollContainerURLECorDasLojas)
	
	VBoxContainerURLECorDasLojas.custom_minimum_size = Vector2(600, 80)
	VBoxContainerURLECorDasLojas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	VBoxContainerURLECorDasLojas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ScrollContainerURLECorDasLojas.add_child(VBoxContainerURLECorDasLojas)
	
	ButtonAdicionarLoja.text = 'Adicionar Loja'
	ButtonAdicionarLoja.custom_minimum_size = Vector2(600, 40)
	ButtonAdicionarLoja.tooltip_text = 'Clique para Adicionar uma Loja para o Produto.'
	ButtonAdicionarLoja.connect('pressed', Callable(self, 'adicionarLoja'))
	ControlJanelaAdicaoEdicao.add_child(ButtonAdicionarLoja)
	
	ButtonCancelarAdicaoOuEdicao.custom_minimum_size = Vector2(290, 40)
	ControlJanelaAdicaoEdicao.add_child(ButtonCancelarAdicaoOuEdicao)
	
	ButtonConfirmarAdicaoOuEdicao.custom_minimum_size = Vector2(290, 40)
	ControlJanelaAdicaoEdicao.add_child(ButtonConfirmarAdicaoOuEdicao)
	
	ConfirmationDialogRemoverLoja.cancel_button_text = 'Não'
	ConfirmationDialogRemoverLoja.ok_button_text = 'Sim'
	ConfirmationDialogRemoverLoja.dialog_autowrap = true
	ConfirmationDialogRemoverLoja.title = 'Remover Loja'
	ConfirmationDialogRemoverLoja.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	ConfirmationDialogRemoverLoja.unresizable = true
	ConfirmationDialogRemoverLoja.min_size = Vector2(160, 90)
	ConfirmationDialogRemoverLoja.max_size = Vector2(8000, 4500)
	ConfirmationDialogRemoverLoja.disable_3d = true
	ConfirmationDialogRemoverLoja.positional_shadow_atlas_size = 0
	ConfirmationDialogRemoverLoja.positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ConfirmationDialogRemoverLoja.positional_shadow_atlas_quad_1 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ConfirmationDialogRemoverLoja.positional_shadow_atlas_quad_2 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ConfirmationDialogRemoverLoja.positional_shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ControlJanelaInicial.add_child(ConfirmationDialogRemoverLoja)
	
	AcceptDialogErrosDaAdicaoOuEdicao.dialog_autowrap = true
	AcceptDialogErrosDaAdicaoOuEdicao.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	AcceptDialogErrosDaAdicaoOuEdicao.unresizable = true
	AcceptDialogErrosDaAdicaoOuEdicao.min_size = Vector2(160, 90)
	AcceptDialogErrosDaAdicaoOuEdicao.max_size = Vector2(8000, 4500)
	AcceptDialogErrosDaAdicaoOuEdicao.disable_3d = true
	AcceptDialogErrosDaAdicaoOuEdicao.positional_shadow_atlas_size = 0
	AcceptDialogErrosDaAdicaoOuEdicao.positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogErrosDaAdicaoOuEdicao.positional_shadow_atlas_quad_1 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogErrosDaAdicaoOuEdicao.positional_shadow_atlas_quad_2 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogErrosDaAdicaoOuEdicao.positional_shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ControlJanelaAdicaoEdicao.add_child(AcceptDialogErrosDaAdicaoOuEdicao)
	
	# Janela Produto
	ControlJanelaProduto.custom_minimum_size = Vector2(640, 360)
	ControlJanelaProduto.visible = false
	ControlJanelaProduto.set_meta('indice_produto', 0)
	ControlJanelaProduto.connect('visibility_changed', Callable(self, 'redimensionamentoInterface'))
	add_child(ControlJanelaProduto)
	
	LabelNomeDoProduto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	LabelNomeDoProduto.clip_text = true
	LabelNomeDoProduto.custom_minimum_size = Vector2(600, 30)
	LabelNomeDoProduto.tooltip_text = 'Nome do Produto.'
	ControlJanelaProduto.add_child(LabelNomeDoProduto)
	
	LabelTagsDoProduto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	LabelTagsDoProduto.clip_text = true
	LabelTagsDoProduto.custom_minimum_size = Vector2(600, 30)
	LabelTagsDoProduto.tooltip_text = 'Tags do Produto.'
	ControlJanelaProduto.add_child(LabelTagsDoProduto)
	
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.fit_to_longest_item = false
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.allow_reselect = true
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.custom_minimum_size = Vector2(600, 40)
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.tooltip_text = 'Escolha entre Incluir os Preços Atuais por Lojas ou Gráfico do Histórico de Preços.'
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.add_item('Incluir Preços Atuais por Loja', 0)
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.add_item('Gráfico do Histórico de Preços', 1)
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.select(0)
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.connect('item_selected', Callable(self, 'incluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos'))
	ControlJanelaProduto.add_child(OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos)
	
	ScrollContainerIncluirPrecosAtuaisPorLoja.follow_focus = true
	ScrollContainerIncluirPrecosAtuaisPorLoja.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ScrollContainerIncluirPrecosAtuaisPorLoja.custom_minimum_size = Vector2(600, 40)
	ControlJanelaProduto.add_child(ScrollContainerIncluirPrecosAtuaisPorLoja)
	
	VBoxContainerIncluirPrecosAtuaisPorLoja.custom_minimum_size = Vector2(600, 40)
	VBoxContainerIncluirPrecosAtuaisPorLoja.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	VBoxContainerIncluirPrecosAtuaisPorLoja.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ScrollContainerIncluirPrecosAtuaisPorLoja.add_child(VBoxContainerIncluirPrecosAtuaisPorLoja)
	
	ButtonIncluirPrecosAtuais.text = 'Incluir Preços Atuais'
	ButtonIncluirPrecosAtuais.custom_minimum_size = Vector2(600, 40)
	ButtonIncluirPrecosAtuais.tooltip_text = 'Clique para Confirmar a Inclusão de Preços Atuais.\nLojas com nenhum Preço digitado serão consideradas como $0.'
	ButtonIncluirPrecosAtuais.connect('pressed', Callable(self, 'incluirPrecosAtuais'))
	ControlJanelaProduto.add_child(ButtonIncluirPrecosAtuais)
	
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.fit_to_longest_item = false
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.allow_reselect = true
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.custom_minimum_size = Vector2(600, 40)
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.tooltip_text = 'Escolha por qual Período o Gráfico do Histórico de Preços exibirá.'
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.visible = false
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.add_item('Dia', 0)
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.add_item('Mês', 1)
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.add_item('Ano', 2)
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.select(0)
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.connect('item_selected', Callable(self, 'gerarGraficoHistoricoDePrecos'))
	ControlJanelaProduto.add_child(OptionButtonGraficoDoHistoricoDePrecosPorPeriodo)
	
	ScrollContainerGraficoDoHistoricoDePrecos.follow_focus = true
	ScrollContainerGraficoDoHistoricoDePrecos.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ScrollContainerGraficoDoHistoricoDePrecos.custom_minimum_size = Vector2(600, 40)
	ScrollContainerGraficoDoHistoricoDePrecos.visible = false
	ScrollContainerGraficoDoHistoricoDePrecos.set_meta('maior_preco', 0.0)
	ControlJanelaProduto.add_child(ScrollContainerGraficoDoHistoricoDePrecos)
	
	VBoxContainerGraficoDoHistoricoDePrecos.custom_minimum_size = Vector2(600, 40)
	VBoxContainerGraficoDoHistoricoDePrecos.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	VBoxContainerGraficoDoHistoricoDePrecos.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ScrollContainerGraficoDoHistoricoDePrecos.add_child(VBoxContainerGraficoDoHistoricoDePrecos)
	
	ButtonVoltarParaJanelaInicial.text = 'Voltar Inicio'
	ButtonVoltarParaJanelaInicial.custom_minimum_size = Vector2(290, 40)
	ButtonVoltarParaJanelaInicial.tooltip_text = 'Clique para voltar à Janela Inicial.'
	ButtonVoltarParaJanelaInicial.connect('pressed', Callable(self, 'voltarParaJanelaInicial'))
	ControlJanelaProduto.add_child(ButtonVoltarParaJanelaInicial)
	
	ButtonEditarDadosDoProduto.text = 'Editar Produto'
	ButtonEditarDadosDoProduto.custom_minimum_size = Vector2(290, 40)
	ButtonEditarDadosDoProduto.tooltip_text = 'Clique para Editar os Dados do Produto.'
	ButtonEditarDadosDoProduto.connect('pressed', Callable(self, 'possivelmenteEditarProduto'))
	ControlJanelaProduto.add_child(ButtonEditarDadosDoProduto)
	
	AcceptDialogErrosDeIncluirPrecosAtuais.dialog_autowrap = true
	AcceptDialogErrosDeIncluirPrecosAtuais.title = 'Erro(s) na Inclusão de Preços'
	AcceptDialogErrosDeIncluirPrecosAtuais.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	AcceptDialogErrosDeIncluirPrecosAtuais.unresizable = true
	AcceptDialogErrosDeIncluirPrecosAtuais.min_size = Vector2(160, 90)
	AcceptDialogErrosDeIncluirPrecosAtuais.max_size = Vector2(8000, 4500)
	AcceptDialogErrosDeIncluirPrecosAtuais.disable_3d = true
	AcceptDialogErrosDeIncluirPrecosAtuais.positional_shadow_atlas_size = 0
	AcceptDialogErrosDeIncluirPrecosAtuais.positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogErrosDeIncluirPrecosAtuais.positional_shadow_atlas_quad_1 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogErrosDeIncluirPrecosAtuais.positional_shadow_atlas_quad_2 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	AcceptDialogErrosDeIncluirPrecosAtuais.positional_shadow_atlas_quad_3 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_DISABLED
	ControlJanelaProduto.add_child(AcceptDialogErrosDeIncluirPrecosAtuais)

func redimensionamentoInterface():
	'''
	Funcao para manter os elements da interface com posicoes e tamanhos corretos.
	Necessario porque no Godot 4.3 so eh possivel definir suas propriedades de 
	lidar com posicionamento e tamanho da interface pela propria interface, nao 
	sendo possivel por codigo. 
	'''
	
	# Variáveis usadas em mais de uma Janela
	var tamanho_janela = get_window().size
	var tamanho_x_menos_borda = tamanho_janela.x - 40
	var tamanho_x_botoes_inferiores = (tamanho_janela.x - 60) * 0.5
	var posicao_y_botoes_inferiores = tamanho_janela.y - 60
	var posicao_x_botao_inferior_direito = tamanho_x_botoes_inferiores + 40
	var posicao_y_botao_superior = tamanho_janela.y - 120
	
	# Control Geral
	size = tamanho_janela
	position = Vector2(0, 0)
	
	if ControlJanelaInicial.visible:
		var tamanho_x_container_tags = tamanho_janela.x - 90
		var tamanho_y_container_produtos = tamanho_janela.y - 220
		
		ControlJanelaInicial.size = tamanho_janela
		ControlJanelaInicial.position = Vector2(0, 0)
		
		LineEditFiltrarProdutoPorNome.size = Vector2(tamanho_x_menos_borda, 40)
		LineEditFiltrarProdutoPorNome.position = Vector2(20, 20)
		
		LabelFiltrarProdutosPorTags.size = Vector2(50, 31)
		LabelFiltrarProdutosPorTags.position = Vector2(20, 80)
		
		ScrollContainerFiltrarProdutosPorTags.size = Vector2(tamanho_x_container_tags, 40)
		ScrollContainerFiltrarProdutosPorTags.position = Vector2(70, 80)
		
		ScrollContainerProdutos.size = Vector2(tamanho_x_menos_borda, tamanho_y_container_produtos)
		ScrollContainerProdutos.position = Vector2(20, 140)
		
		ButtonSobreOPrograma.size = Vector2(tamanho_x_botoes_inferiores, 40)
		ButtonSobreOPrograma.position = Vector2(20, posicao_y_botoes_inferiores)
		
		ButtonAdicionarProduto.size = Vector2(tamanho_x_botoes_inferiores, 40)
		ButtonAdicionarProduto.position = Vector2(posicao_x_botao_inferior_direito, posicao_y_botoes_inferiores)
		
		for ButtonIrParaProduto in VBoxContainerProdutos.get_children():
			var ButtonRemoverProduto = ButtonIrParaProduto.get_child(0)
			var LabelNomeProduto = ButtonIrParaProduto.get_child(1)
			var LabelTagsProduto = ButtonIrParaProduto.get_child(2)
			var LabelPrecoMedio = ButtonIrParaProduto.get_child(3)
			
			var tamanho_x_preco = min(320, len(LabelPrecoMedio.text) * 20, tamanho_janela.x - 430)
			var tamanho_x_nome_tags = tamanho_janela.x - tamanho_x_preco - 270
			var posicao_x_preco = tamanho_x_nome_tags + 210
			
			ButtonRemoverProduto.size = Vector2(150, 60)
			ButtonRemoverProduto.position = Vector2(20, 20)
			
			LabelNomeProduto.size = Vector2(tamanho_x_nome_tags, 30)
			LabelNomeProduto.position = Vector2(190, 20)
			
			LabelTagsProduto.size = Vector2(tamanho_x_nome_tags, 30)
			LabelTagsProduto.position = Vector2(190, 50)
			
			LabelPrecoMedio.size = Vector2(tamanho_x_preco, 60)
			LabelPrecoMedio.position = Vector2(posicao_x_preco, 20)
	
	elif ControlJanelaAdicaoEdicao.visible:
		var tamanho_y_container_lojas = tamanho_janela.y - 280
		var tamanho_x_url_loja = tamanho_janela.x - 280
		var posicao_x_remover_loja = tamanho_janela.x - 180
		
		ControlJanelaAdicaoEdicao.size = tamanho_janela
		ControlJanelaAdicaoEdicao.position = Vector2(0, 0)
		
		LineEditNomeDoProduto.size = Vector2(tamanho_x_menos_borda, 40)
		LineEditNomeDoProduto.position = Vector2(20, 20)
		
		LineEditTagsDoProduto.size = Vector2(tamanho_x_menos_borda, 40)
		LineEditTagsDoProduto.position = Vector2(20, 80)
		
		ScrollContainerURLECorDasLojas.size = Vector2(tamanho_x_menos_borda, tamanho_y_container_lojas)
		ScrollContainerURLECorDasLojas.position = Vector2(20, 140)
		
		ButtonAdicionarLoja.size = Vector2(tamanho_x_menos_borda, 40)
		ButtonAdicionarLoja.position = Vector2(20, posicao_y_botao_superior)
		
		ButtonCancelarAdicaoOuEdicao.size = Vector2(tamanho_x_botoes_inferiores, 40)
		ButtonCancelarAdicaoOuEdicao.position = Vector2(20, posicao_y_botoes_inferiores)
		
		ButtonConfirmarAdicaoOuEdicao.size = Vector2(tamanho_x_botoes_inferiores, 40)
		ButtonConfirmarAdicaoOuEdicao.position = Vector2(posicao_x_botao_inferior_direito, posicao_y_botoes_inferiores)
		
		for PanelLoja in VBoxContainerURLECorDasLojas.get_children():
			var ColorPickerButtonCorLoja = PanelLoja.get_child(0)
			var LineEditURLLoja = PanelLoja.get_child(1)
			var ButtonRemoverLoja = PanelLoja.get_child(2)
			
			ColorPickerButtonCorLoja.size = Vector2(40, 40)
			ColorPickerButtonCorLoja.position = Vector2(20, 20)
			
			LineEditURLLoja.size = Vector2(tamanho_x_url_loja, 40)
			LineEditURLLoja.position = Vector2(80, 20)
			
			ButtonRemoverLoja.size = Vector2(120, 40)
			ButtonRemoverLoja.position = Vector2(posicao_x_remover_loja, 20)
	
	elif ControlJanelaProduto.visible:
		var tamanho_y_containers = tamanho_janela.y - 320
		var tamanho_x_pagina_produto = tamanho_janela.x - 260
		var posicao_x_preco_produto = tamanho_janela.x - 220
		var tamanho_x_historico_preco_menos_borda = tamanho_janela.x - 80
		
		ControlJanelaProduto.size = tamanho_janela
		ControlJanelaProduto.position = Vector2(0, 0)
		
		LabelNomeDoProduto.size = Vector2(tamanho_x_menos_borda, 30)
		LabelNomeDoProduto.position = Vector2(20, 20)
		
		LabelTagsDoProduto.size = Vector2(tamanho_x_menos_borda, 30)
		LabelTagsDoProduto.position = Vector2(20, 70)
		
		OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.size = Vector2(tamanho_x_menos_borda, 40)
		OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.position = Vector2(20, 120)
		
		ScrollContainerIncluirPrecosAtuaisPorLoja.size = Vector2(tamanho_x_menos_borda, tamanho_y_containers)
		ScrollContainerIncluirPrecosAtuaisPorLoja.position = Vector2(20, 180)
		
		ButtonIncluirPrecosAtuais.size = Vector2(tamanho_x_menos_borda, 40)
		ButtonIncluirPrecosAtuais.position = Vector2(20, posicao_y_botao_superior)
		
		OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.size = Vector2(tamanho_x_menos_borda, 40)
		OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.position = Vector2(20, 180)
		
		ScrollContainerGraficoDoHistoricoDePrecos.size = Vector2(tamanho_x_menos_borda, tamanho_y_containers)
		ScrollContainerGraficoDoHistoricoDePrecos.position = Vector2(20, 240)
		
		ButtonVoltarParaJanelaInicial.size = Vector2(tamanho_x_botoes_inferiores, 40)
		ButtonVoltarParaJanelaInicial.position = Vector2(20, posicao_y_botoes_inferiores)
		
		ButtonEditarDadosDoProduto.size = Vector2(tamanho_x_botoes_inferiores, 40)
		ButtonEditarDadosDoProduto.position = Vector2(posicao_x_botao_inferior_direito, posicao_y_botoes_inferiores)
		
		for PanelLoja in VBoxContainerIncluirPrecosAtuaisPorLoja.get_children():
			var LinkButtonPaginaDoProdutoDaLoja = PanelLoja.get_child(0)
			var LineEditPrecoDoProdutoDaLoja = PanelLoja.get_child(1)
			
			LinkButtonPaginaDoProdutoDaLoja.size = Vector2(tamanho_x_pagina_produto, 40)
			LinkButtonPaginaDoProdutoDaLoja.position = Vector2(20, 20)
			
			LineEditPrecoDoProdutoDaLoja.size = Vector2(160, 40)
			LineEditPrecoDoProdutoDaLoja.position = Vector2(posicao_x_preco_produto, 20)
		
		for PanelHistoricoDePrecos in VBoxContainerGraficoDoHistoricoDePrecos.get_children():
			var LabelData = PanelHistoricoDePrecos.get_child(0)
			var maior_preco = ScrollContainerGraficoDoHistoricoDePrecos.get_meta('maior_preco')
			var indice_loja = 1
			
			PanelHistoricoDePrecos.custom_minimum_size.y = (PanelHistoricoDePrecos.get_child_count() * 30) + 40
			
			LabelData.size = Vector2(tamanho_x_historico_preco_menos_borda, 30)
			LabelData.position = Vector2(20, 20)
			
			while indice_loja < PanelHistoricoDePrecos.get_child_count():
				var posicao_y = (indice_loja * 30) + 20
				
				if PanelHistoricoDePrecos.get_child(indice_loja) is ColorRect:
					var ColorRectPreco = PanelHistoricoDePrecos.get_child(indice_loja)
					var LabelLoja = ColorRectPreco.get_child(0)
					var LabelPreco = ColorRectPreco.get_child(1)
					
					var multiplicador_tamanho_x = float(converterTextoParaNumero(LabelPreco.text)) / maior_preco
					var tamanho_x_retangulo_preco = round(multiplicador_tamanho_x * tamanho_x_historico_preco_menos_borda)
					var tamanho_x_preco = min(160, len(LabelPreco.text) * 10, tamanho_x_retangulo_preco)
					var tamanho_x_loja = max(0, tamanho_x_retangulo_preco - tamanho_x_preco)
					var posicao_x_preco = tamanho_x_retangulo_preco - tamanho_x_preco
					
					ColorRectPreco.size = Vector2(tamanho_x_retangulo_preco, 30)
					ColorRectPreco.position = Vector2(20, posicao_y)
					
					LabelLoja.size = Vector2(tamanho_x_loja, 30)
					LabelLoja.position = Vector2(0, 0)
					
					LabelPreco.size = Vector2(tamanho_x_preco, 30)
					LabelPreco.position = Vector2(posicao_x_preco, 0)
				else:
					var LabelSemPreco = PanelHistoricoDePrecos.get_child(indice_loja)
					
					LabelSemPreco.size = Vector2(tamanho_x_historico_preco_menos_borda, 30)
					LabelSemPreco.position = Vector2(20, posicao_y)
				indice_loja += 1

func salvarDados():
	if len(nomes_produtos) > 0:
		var texto_dados = '{\n\t\"nomes_produtos\": [\n\t\t\"'
		var indice_produto = 0
		while indice_produto < len(nomes_produtos):
			texto_dados += nomes_produtos[indice_produto]
			indice_produto += 1
			if indice_produto < len(nomes_produtos):
				texto_dados += '\",\n\t\t\"'
		texto_dados += '\"\n\t],\n\t\"tags_produtos\": [\n\t\t[\n\t\t\t\"'
		indice_produto = 0
		while indice_produto < len(tags_produtos):
			var indice_tag = 0
			while indice_tag < len(tags_produtos[indice_produto]):
				texto_dados += tags_produtos[indice_produto][indice_tag]
				indice_tag += 1
				if indice_tag < len(tags_produtos[indice_produto]):
					texto_dados += '\",\n\t\t\t\"'
			indice_produto += 1
			if indice_produto < len(tags_produtos):
				texto_dados += '\"\n\t\t],\n\t\t[\n\t\t\t\"'
		texto_dados += '\"\n\t\t]\n\t],\n\t\"cor_lojas_produtos\": [\n\t\t[\n\t\t\t{\n\t\t\t\t\"r\": '
		indice_produto = 0
		while indice_produto < len(cor_lojas_produtos):
			var indice_loja = 0
			while indice_loja < len(cor_lojas_produtos[indice_produto]):
				var cor = cor_lojas_produtos[indice_produto][indice_loja]
				texto_dados += str(cor.r8) + ',\n\t\t\t\t\"g\": ' + str(cor.g8) + ',\n\t\t\t\t\"b\": ' + str(cor.b8)
				indice_loja += 1
				if indice_loja < len(cor_lojas_produtos[indice_produto]):
					texto_dados += '\n\t\t\t},\n\t\t\t{\n\t\t\t\t\"r\": '
			indice_produto += 1
			if indice_produto < len(cor_lojas_produtos):
				texto_dados += '\n\t\t\t}\n\t\t],\n\t\t[\n\t\t\t{\n\t\t\t\t\"r\": '
		texto_dados += '\n\t\t\t}\n\t\t]\n\t],\n\t\"url_lojas_produtos\": [\n\t\t[\n\t\t\t\"'
		indice_produto = 0
		while indice_produto < len(url_lojas_produtos):
			var indice_loja = 0
			while indice_loja < len(url_lojas_produtos[indice_produto]):
				texto_dados += url_lojas_produtos[indice_produto][indice_loja]
				indice_loja += 1
				if indice_loja < len(url_lojas_produtos[indice_produto]):
					texto_dados += '\",\n\t\t\t\"'
			indice_produto += 1
			if indice_produto < len(url_lojas_produtos):
				texto_dados += '\"\n\t\t],\n\t\t[\n\t\t\t\"'
		texto_dados += '\"\n\t\t]\n\t],\n\t\"data_lojas_produtos\": [\n\t\t[\n\t\t\t{\n\t\t\t\t\"year\": '
		indice_produto = 0
		while indice_produto < len(data_lojas_produtos):
			var indice_data = 0
			while indice_data < len(data_lojas_produtos[indice_produto]):
				var data = data_lojas_produtos[indice_produto][indice_data]
				texto_dados += str(data["year"]) + ',\n\t\t\t\t\"month\": ' + str(data["month"]) + ',\n\t\t\t\t\"day\": ' + str(data["day"]) + ',\n\t\t\t\t\"weekday\": ' + str(data["weekday"])
				indice_data += 1
				if indice_data < len(data_lojas_produtos[indice_produto]):
					texto_dados += '\n\t\t\t},\n\t\t\t{\n\t\t\t\t\"year\": '
			indice_produto += 1
			if indice_produto < len(data_lojas_produtos):
				texto_dados += '\n\t\t\t}\n\t\t],\n\t\t[\n\t\t\t{\n\t\t\t\t\"year\": '
		texto_dados += '\n\t\t\t}\n\t\t]\n\t],\n\t\"preco_lojas_produtos\": [\n\t\t[\n\t\t\t[\n\t\t\t\t'
		indice_produto = 0
		while indice_produto < len(preco_lojas_produtos):
			var indice_loja = 0
			while indice_loja < len(preco_lojas_produtos[indice_produto]):
				var indice_preco = 0
				while indice_preco < len(preco_lojas_produtos[indice_produto][indice_loja]):
					texto_dados += str(preco_lojas_produtos[indice_produto][indice_loja][indice_preco])
					indice_preco += 1
					if indice_preco < len(preco_lojas_produtos[indice_produto][indice_loja]):
						texto_dados += ',\n\t\t\t\t'
				indice_loja += 1
				if indice_loja < len(preco_lojas_produtos[indice_produto]):
					texto_dados += '\n\t\t\t],\n\t\t\t[\n\t\t\t\t'
			indice_produto += 1
			if indice_produto < len(preco_lojas_produtos):
				texto_dados += '\n\t\t\t]\n\t\t],\n\t\t[\n\t\t\t[\n\t\t\t\t'
		texto_dados += '\n\t\t\t]\n\t\t]\n\t]\n}'
		var FileAccessArquivoJSON = FileAccess.open('res://dados.json', FileAccess.WRITE)
		FileAccessArquivoJSON.store_string(texto_dados)

func carregarDados():
	var JSONDados = JSON.parse_string(FileAccess.get_file_as_string('res://dados.json'))
	if JSONDados != null:
		var cores_lojas = []
		for produto in JSONDados["cor_lojas_produtos"]:
			cores_lojas.append([])
			for cor in produto:
				cores_lojas[-1].append(Color8(int(cor["r"]), int(cor["g"]), int(cor["b"]), 255))
		nomes_produtos = JSONDados["nomes_produtos"]
		tags_produtos = JSONDados["tags_produtos"]
		cor_lojas_produtos = cores_lojas
		url_lojas_produtos = JSONDados["url_lojas_produtos"]
		data_lojas_produtos = JSONDados["data_lojas_produtos"]
		preco_lojas_produtos = JSONDados["preco_lojas_produtos"]

# Funcoes Logicas (recebem input e retornam output)
func textoTagsParaLista(texto_tags):
	var lista_tags = []
	var tag_atual = ''
	for letra in texto_tags:
		if letra == ',':
			if tag_atual.strip_edges() != '':
				lista_tags.append(tag_atual.strip_edges())
			tag_atual = ''
		else:
			tag_atual += letra
	if tag_atual.strip_edges() != '':
		lista_tags.append(tag_atual.strip_edges())
	return lista_tags

func listaTagsParaTexto(lista_tags):
	var texto = ''
	var indice_lista = 0
	while indice_lista < len(lista_tags):
		texto += lista_tags[indice_lista]
		indice_lista += 1
		if indice_lista < len(lista_tags):
			texto += ', '
	return texto

func listaErrosParaTexto(lista_erros):
	var texto = ''
	var indice_lista = 0
	while indice_lista < len(lista_erros):
		texto += lista_erros[indice_lista]
		indice_lista += 1
		if indice_lista < len(lista_erros):
			texto += '\n'
	return texto

func precoMedio(lista_precos):
	var preco_medio = 0
	var contador_precos = 0
	for preco in lista_precos:
		preco_medio += preco
		contador_precos += 1
	if contador_precos > 0:
		return preco_medio / contador_precos
	return 0

func precoMedioLojas(lista_precos_loja):
	var preco_medio = 0
	var contador_precos = 0
	for loja in lista_precos_loja:
		for preco in loja:
			if preco > 0:
				preco_medio += preco
				contador_precos += 1
	if preco_medio != 0:
		preco_medio = round((preco_medio / contador_precos) * 100) * 0.01
	return preco_medio

func hostLoja(url):
	var host_loja = ''
	var substring = ''
	var indice_letra = 0
	while indice_letra + 2 < len(url):
		substring = url[indice_letra] + url[indice_letra + 1] + url[indice_letra + 2]
		if substring == '://':
			indice_letra += 3
			break
		indice_letra += 1
	while indice_letra < len(url):
		if url[indice_letra] == '/':
			break
		host_loja += url[indice_letra]
		indice_letra += 1
	return host_loja.strip_edges()

func divisorDecimal(texto_numero):
	var quantidade_virgula = 0
	var quantidade_ponto = 0
	var primeiro = ''
	var anterior = ''
	var indice_invertido_letra = len(texto_numero) - 1
	while indice_invertido_letra > -1:
		match texto_numero[indice_invertido_letra]:
			',':
				if anterior != ',':
					if primeiro == '':
						primeiro = ','
					quantidade_virgula += 1
				anterior = ','
			'.':
				if anterior != '.':
					if primeiro == '':
						primeiro = '.'
					quantidade_ponto += 1
				anterior = '.'
			_:
				anterior = ''
		indice_invertido_letra -= 1
	if (quantidade_virgula == 0) and (quantidade_ponto == 0):
		return 'inteiro'
	elif (quantidade_virgula == 1) and (quantidade_ponto == 1):
		return primeiro
	elif quantidade_virgula == 1:
		return ','
	elif quantidade_ponto == 1:
		return '.'
	return 'erro'

func converterTextoParaNumero(texto_numero):
	var numero = ''
	var divisor_decimal = divisorDecimal(texto_numero)
	if (divisor_decimal == 'erro') or (texto_numero == ''):
		return 'erro'
	for letra in texto_numero:
		match letra:
			'0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
				numero += letra
			divisor_decimal:
				numero += '.'
	if numero == '':
		return 'erro'
	elif numero[0] == '.':
		numero = '0' + numero
	elif divisor_decimal == 'inteiro':
		return int(numero)
	return float(numero)

func formatarData(data, formato = ['d', 'm', 'a']):
	var data_formatada = ''
	var indice_periodo = 0
	while indice_periodo < len(formato):
		match formato[indice_periodo][0]:
			'd', 'D':
				data_formatada += str(data['day'])
			'm', 'M':
				data_formatada += str(data['month'])
			'a', 'A':
				data_formatada += str(data['year'])
		indice_periodo += 1
		if indice_periodo < len(formato):
			data_formatada += '-'
	return data_formatada

func datasPeriodo(datas_preco, periodo = 'd'):
	var datas_por_periodo = []
	var data_formatada = ''
	var indice_data = 0
	while indice_data < len(datas_preco):
		match periodo[0]:
			'd', 'D':
				data_formatada = formatarData(datas_preco[indice_data])
				datas_por_periodo.append(data_formatada)
			'm', 'M':
				data_formatada = formatarData(datas_preco[indice_data], ['m', 'a'])
				if data_formatada not in datas_por_periodo:
					datas_por_periodo.append(data_formatada)
			'a', 'A':
				data_formatada = formatarData(datas_preco[indice_data], ['a'])
				if data_formatada not in datas_por_periodo:
					datas_por_periodo.append(data_formatada)
		indice_data += 1
	return datas_por_periodo

func precosPeriodo(datas_preco, precos_loja, periodo = 'd'):
	var precos_por_periodo = []
	var indice_loja = 0
	while indice_loja < len(precos_loja):
		precos_por_periodo.append([])
		match periodo[0]:
			'd', 'D':
				precos_por_periodo[-1] = precos_loja[indice_loja]
			'm', 'M':
				var mes_ano_precos = {}
				for data in range(len(datas_preco)):
					var mes_ano_chave = formatarData(datas_preco[data], ['a', 'm'])
					if mes_ano_chave not in mes_ano_precos:
						mes_ano_precos[mes_ano_chave] = []
					mes_ano_precos[mes_ano_chave].append(precos_loja[indice_loja][data])
				for chave in mes_ano_precos:
					precos_por_periodo[-1].append(precoMedio(mes_ano_precos[chave]))
			'a', 'A':
				var ano_precos = {}
				for data in range(len(datas_preco)):
					var ano_chave = formatarData(datas_preco[data], ['a'])
					if ano_chave not in ano_precos:
						ano_precos[ano_chave] = []
					ano_precos[ano_chave].append(precos_loja[indice_loja][data])
				for chave in ano_precos:
					precos_por_periodo[-1].append(precoMedio(ano_precos[chave]))
		indice_loja += 1
	return precos_por_periodo

func removerDatasNaoUtilizadas(datas_produto, precos_produto):
	var datas = datas_produto
	var precos = precos_produto
	var lojas_com_zero = 0
	var indice_data = len(datas_produto) - 2
	while indice_data >= 0:
		lojas_com_zero = 0
		for loja in precos_produto:
			if loja[indice_data] == 0 or loja[indice_data] == 0.0:
				lojas_com_zero += 1
		if lojas_com_zero == len(precos_produto):
			datas.pop_at(indice_data)
			for loja in precos:
				loja.pop_at(indice_data)
		indice_data -= 1
	return [datas, precos]

# Funcoes Janela Inicial
func filtrarProdutosPorNomeETags(nome_filtrado = ''):
	var CheckBoxTag = null
	var ButtonIrParaProduto = null
	var ButtonRemoverProduto = null
	var LabelNomeProduto = null
	var LabelTagsProduto = null
	var LabelPrecoMedio = null
	var nome_filtrado_em_algum_produto = false
	var produto_atende_filtros = true
	var algum_produto_atende_filtros = false
	var tags_filtradas = []
	var tags_dos_produtos_filtrados = []
	var indice_produto = 0
	nome_filtrado = LineEditFiltrarProdutoPorNome.text
	if nome_filtrado != '':
		for nome in nomes_produtos:
			if nome_filtrado in nome:
				nome_filtrado_em_algum_produto = true
				break
		
		if nome_filtrado_em_algum_produto:
			LineEditFiltrarProdutoPorNome.set_meta('ultimo_nome_filtrado', nome_filtrado)
		else:
			nome_filtrado = LineEditFiltrarProdutoPorNome.get_meta('ultimo_nome_filtrado')
			LineEditFiltrarProdutoPorNome.text = nome_filtrado
			LineEditFiltrarProdutoPorNome.caret_column = len(nome_filtrado)
	
	for check_box_tag in HBoxContainerFiltrarProdutosPorTags.get_children():
		if check_box_tag.button_pressed:
			tags_filtradas.append(check_box_tag.text)
	
	for button_ir_para_produto in VBoxContainerProdutos.get_children():
		button_ir_para_produto.queue_free()
	
	while indice_produto < len(nomes_produtos):
		produto_atende_filtros = true
		
		if (nome_filtrado != '') and (nome_filtrado not in nomes_produtos[indice_produto]):
			produto_atende_filtros = false
		
		for tag_filtrada in tags_filtradas:
			if tag_filtrada not in tags_produtos[indice_produto]:
				produto_atende_filtros = false
				break
		
		if produto_atende_filtros:
			algum_produto_atende_filtros = true
			
			for tag in tags_produtos[indice_produto]:
				if tag not in tags_dos_produtos_filtrados:
					tags_dos_produtos_filtrados.append(tag)
			
			ButtonIrParaProduto = Button.new()
			ButtonRemoverProduto = Button.new()
			LabelNomeProduto = Label.new()
			LabelTagsProduto = Label.new()
			LabelPrecoMedio = Label.new()
			
			ButtonIrParaProduto.custom_minimum_size = Vector2(600, 100)
			ButtonIrParaProduto.tooltip_text = 'Clique para ir à Página do Produto.'
			ButtonIrParaProduto.connect('pressed', Callable(self, 'irParaProduto').bind(indice_produto))
			VBoxContainerProdutos.add_child(ButtonIrParaProduto)
			
			ButtonRemoverProduto.text = 'Remover Produto'
			ButtonRemoverProduto.custom_minimum_size = Vector2(150, 60)
			ButtonRemoverProduto.tooltip_text = 'Clique para Remover o Produto.'
			ButtonRemoverProduto.connect('pressed', Callable(self, 'possivelmenteRemoverProduto').bind(indice_produto))
			ButtonIrParaProduto.add_child(ButtonRemoverProduto)
			
			LabelNomeProduto.text = nomes_produtos[indice_produto]
			LabelNomeProduto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			LabelNomeProduto.clip_text = true
			LabelNomeProduto.custom_minimum_size = Vector2(160, 30)
			LabelNomeProduto.tooltip_text = 'Nome do Produto.'
			ButtonIrParaProduto.add_child(LabelNomeProduto)
			
			LabelTagsProduto.text = listaTagsParaTexto(tags_produtos[indice_produto])
			LabelTagsProduto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			LabelTagsProduto.clip_text = true
			LabelTagsProduto.custom_minimum_size = Vector2(160, 30)
			LabelTagsProduto.tooltip_text = 'Tags do Produto.'
			ButtonIrParaProduto.add_child(LabelTagsProduto)
			
			LabelPrecoMedio.text = '$' + str(precoMedioLojas(preco_lojas_produtos[indice_produto]))
			LabelPrecoMedio.label_settings = LabelSettingsPrecoMedio
			LabelPrecoMedio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			LabelPrecoMedio.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			LabelPrecoMedio.clip_text = true
			LabelPrecoMedio.custom_minimum_size = Vector2(20, 60)
			LabelPrecoMedio.tooltip_text = 'Preço Médio do Produto.'
			ButtonIrParaProduto.add_child(LabelPrecoMedio)
		indice_produto += 1
	
	if (not algum_produto_atende_filtros) and (len(nomes_produtos) > 0):
		LineEditFiltrarProdutoPorNome.text = ''
		LineEditFiltrarProdutoPorNome.set_meta('ultimo_nome_filtrado', '')
		for check_box_tag in HBoxContainerFiltrarProdutosPorTags.get_children():
			check_box_tag.button_pressed = false
		tags_filtradas.clear()
		filtrarProdutosPorNomeETags()
	else:
		for check_box_tag in HBoxContainerFiltrarProdutosPorTags.get_children():
			check_box_tag.queue_free()
		
		for tag in tags_dos_produtos_filtrados:
			CheckBoxTag = CheckBox.new()
			CheckBoxTag.text = tag
			if tag in tags_filtradas:
				CheckBoxTag.button_pressed = true
			CheckBoxTag.tooltip_text = 'Clique para exibir Produtos que contenham essa Tag.'
			CheckBoxTag.connect('pressed', Callable(self, 'filtrarProdutosPorNomeETags'))
			HBoxContainerFiltrarProdutosPorTags.add_child(CheckBoxTag)
	redimensionamentoInterface()

func irParaProduto(indice_produto):
	ControlJanelaInicial.visible = false
	LabelNomeDoProduto.text = nomes_produtos[indice_produto]
	LabelTagsDoProduto.text = listaTagsParaTexto(tags_produtos[indice_produto])
	ControlJanelaProduto.set_meta('indice_produto', indice_produto)
	OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.select(0)
	OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.select(0)
	carregarPrecosPorLoja()
	gerarGraficoHistoricoDePrecos()
	ControlJanelaProduto.visible = true

func possivelmenteRemoverProduto(indice_produto):
	var tamanho_x = round(get_window().size.x * 0.25)
	ConfirmationDialogRemoverProduto.dialog_text = 'Deseja Remover o Produto \"' + nomes_produtos[indice_produto] + '\" e seus dados permanentemente?'
	ConfirmationDialogRemoverProduto.size = Vector2(tamanho_x, 0)
	if ConfirmationDialogRemoverProduto.is_connected('confirmed', Callable(self, 'removerProduto')):
		ConfirmationDialogRemoverProduto.disconnect('confirmed', Callable(self, 'removerProduto'))
	ConfirmationDialogRemoverProduto.connect('confirmed', Callable(self, 'removerProduto').bind(indice_produto))
	ConfirmationDialogRemoverProduto.visible = true

func removerProduto(indice_produto):
	nomes_produtos.pop_at(indice_produto)
	tags_produtos.pop_at(indice_produto)
	url_lojas_produtos.pop_at(indice_produto)
	cor_lojas_produtos.pop_at(indice_produto)
	data_lojas_produtos.pop_at(indice_produto)
	preco_lojas_produtos.pop_at(indice_produto)
	filtrarProdutosPorNomeETags()

func sobrePrograma():
	var tamanho_x = round(get_window().size.x * 0.25)
	AcceptDialogSobreOPrograma.size = Vector2(tamanho_x, 0)
	AcceptDialogSobreOPrograma.visible = true

func possivelmenteAdicionarProduto():
	ControlJanelaInicial.visible = false
	LineEditNomeDoProduto.text = ''
	LineEditTagsDoProduto.text = ''
	ScrollContainerURLECorDasLojas.set_meta('lista_lojas', [])
	ScrollContainerURLECorDasLojas.set_meta('janela_adicao', true)
	ButtonCancelarAdicaoOuEdicao.text = 'Cancelar Adição'
	if ButtonCancelarAdicaoOuEdicao.is_connected('pressed', Callable(self, 'cancelarEdicao')):
		ButtonCancelarAdicaoOuEdicao.disconnect('pressed', Callable(self, 'cancelarEdicao'))
	ButtonCancelarAdicaoOuEdicao.tooltip_text = 'Clique para Cancelar a Adição do Produto e Voltar à Janela Inicial.'
	ButtonCancelarAdicaoOuEdicao.connect('pressed', Callable(self, 'cancelarAdicao'))
	ButtonConfirmarAdicaoOuEdicao.text = 'Confirmar Adição'
	if ButtonConfirmarAdicaoOuEdicao.is_connected('pressed', Callable(self, 'confirmarEdicao')):
		ButtonConfirmarAdicaoOuEdicao.disconnect('pressed', Callable(self, 'confirmarEdicao'))
	ButtonConfirmarAdicaoOuEdicao.tooltip_text = 'Clique para Confirmar a Adição do Produto e ir à sua Página.'
	ButtonConfirmarAdicaoOuEdicao.connect('pressed', Callable(self, 'confirmarAdicao'))
	AcceptDialogErrosDaAdicaoOuEdicao.title = 'Erro(s) na Adição do Produto'
	atualizarPainelDeLojas()
	ControlJanelaAdicaoEdicao.visible = true

# Funcoes Janela Adicao e Edicao
func adicionarLoja():
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	lista_lojas.append([Color(1, 1, 1), '', null])
	ScrollContainerURLECorDasLojas.set_meta('lista_lojas', lista_lojas)
	atualizarPainelDeLojas()

func atualizarPainelDeLojas():
	var PanelLoja = null
	var ColorPickerButtonCorLoja = null
	var LineEditURLLoja = null
	var ButtonRemoverLoja = null
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	var indice_loja = 0
	
	for panel_loja in VBoxContainerURLECorDasLojas.get_children():
		panel_loja.queue_free()
	
	while indice_loja < len(lista_lojas):
		PanelLoja = Panel.new()
		ColorPickerButtonCorLoja = ColorPickerButton.new()
		LineEditURLLoja = LineEdit.new()
		ButtonRemoverLoja = Button.new()
		
		PanelLoja.custom_minimum_size = Vector2(600, 80)
		VBoxContainerURLECorDasLojas.add_child(PanelLoja)
		
		ColorPickerButtonCorLoja.color = lista_lojas[indice_loja][0]
		ColorPickerButtonCorLoja.edit_alpha = false
		ColorPickerButtonCorLoja.custom_minimum_size = Vector2(40, 40)
		ColorPickerButtonCorLoja.tooltip_text = 'Escolha que Cor a Loja terá.'
		ColorPickerButtonCorLoja.connect('color_changed', Callable(self, 'atualizarListaLojas'))
		PanelLoja.add_child(ColorPickerButtonCorLoja)
		
		LineEditURLLoja.text = lista_lojas[indice_loja][1]
		LineEditURLLoja.placeholder_text = 'URL da Página do Produto na Loja'
		LineEditURLLoja.select_all_on_focus = true
		LineEditURLLoja.custom_minimum_size = Vector2(360, 40)
		LineEditURLLoja.tooltip_text = 'Tenha certeza de escrever o protocolo do Endereço da Loja.'
		LineEditURLLoja.connect('text_changed', Callable(self, 'atualizarListaLojas'))
		PanelLoja.add_child(LineEditURLLoja)
		
		ButtonRemoverLoja.text = 'Remover Loja'
		ButtonRemoverLoja.custom_minimum_size = Vector2(120, 40)
		ButtonRemoverLoja.tooltip_text = 'Clique para Remover a Loja.'
		ButtonRemoverLoja.connect('pressed', Callable(self, 'possivelmenteRemoverLoja').bind(indice_loja))
		PanelLoja.add_child(ButtonRemoverLoja)
		
		indice_loja += 1
	redimensionamentoInterface()

func atualizarListaLojas(_cor = Color(1, 1, 1), _url = ''):
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	var ColorPickerButtonCorLoja = null
	var LineEditURLLoja = null
	var indice_loja = 0
	while indice_loja < VBoxContainerURLECorDasLojas.get_child_count():
		var PanelLoja = VBoxContainerURLECorDasLojas.get_child(indice_loja)
		ColorPickerButtonCorLoja = PanelLoja.get_child(0)
		LineEditURLLoja = PanelLoja.get_child(1)
		lista_lojas[indice_loja][0] = ColorPickerButtonCorLoja.color
		lista_lojas[indice_loja][1] = LineEditURLLoja.text
		indice_loja += 1
	ScrollContainerURLECorDasLojas.set_meta('lista_lojas', lista_lojas)

func possivelmenteRemoverLoja(indice_loja):
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	var tamanho_x = round(get_window().size.x * 0.25)
	if ScrollContainerURLECorDasLojas.get_meta('janela_adicao') or (lista_lojas[indice_loja][2] == null):
		removerLoja(indice_loja)
	else:
		ConfirmationDialogRemoverLoja.dialog_text = 'Deseja Remover a Loja \"' + hostLoja(lista_lojas[indice_loja][1]) + '\" e seus Dados permanentemente?'
		ConfirmationDialogRemoverLoja.size = Vector2(tamanho_x, 0)
		if ConfirmationDialogRemoverLoja.is_connected('confirmed', Callable(self, 'removerLoja')):
			ConfirmationDialogRemoverLoja.disconnect('confirmed', Callable(self, 'removerLoja'))
		ConfirmationDialogRemoverLoja.connect('confirmed', Callable(self, 'removerLoja').bind(indice_loja))
		ConfirmationDialogRemoverLoja.visible = true

func removerLoja(indice_loja):
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	var remover_loja_antiga = ScrollContainerURLECorDasLojas.get_meta('remover_loja_antiga')
	if (not ScrollContainerURLECorDasLojas.get_meta('janela_adicao')) and (lista_lojas[indice_loja][2] != null):
		remover_loja_antiga[lista_lojas[indice_loja][2]] = true
	lista_lojas.pop_at(indice_loja)
	ScrollContainerURLECorDasLojas.set_meta('lista_lojas', lista_lojas)
	ScrollContainerURLECorDasLojas.set_meta('remover_loja_antiga', remover_loja_antiga)
	atualizarPainelDeLojas()

func erroAdicaoOuEdicao():
	var mensagens_erros = []
	var mensagem_erro = ''
	var tamanho_x = 0
	
	if (LineEditNomeDoProduto.text in nomes_produtos) and ScrollContainerURLECorDasLojas.get_meta('janela_adicao'):
		mensagens_erros.append('Este produto ja esta no banco de dados!')
	
	if LineEditNomeDoProduto.text == '':
		mensagens_erros.append('O produto precisa ter um Nome!')
	
	if LineEditTagsDoProduto.text == '':
		mensagens_erros.append('O produto precisa ter ao menos uma Tag!')
	
	if VBoxContainerURLECorDasLojas.get_child_count() == 0:
		mensagens_erros.append('O produto precisa ter ao menos uma Loja!')
	else:
		for PanelLoja in VBoxContainerURLECorDasLojas.get_children():
			if PanelLoja.get_child(1).text == '':
				mensagens_erros.append('O produto não pode ter uma loja sem URL!')
				break
	
	if len(mensagens_erros) > 0:
		if len(mensagens_erros) == 1:
			mensagem_erro = mensagens_erros[0]
		else:
			mensagem_erro = listaErrosParaTexto(mensagens_erros)
		
		tamanho_x = round(get_window().size.x * 0.25)
		AcceptDialogErrosDaAdicaoOuEdicao.dialog_text = mensagem_erro
		AcceptDialogErrosDaAdicaoOuEdicao.size = Vector2(tamanho_x, 0)
		AcceptDialogErrosDaAdicaoOuEdicao.visible = true

# Funcoes Janela Adicao
func cancelarAdicao():
	ControlJanelaAdicaoEdicao.visible = false
	ControlJanelaInicial.visible = true

func confirmarAdicao():
	var indice_produto = 0
	var lista_lojas_precos_vazios = []
	var lista_cores = []
	var lista_urls = []
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	var hoje = Time.get_date_dict_from_system()
	erroAdicaoOuEdicao()
	if not AcceptDialogErrosDaAdicaoOuEdicao.visible:
		ControlJanelaAdicaoEdicao.visible = false
		for loja in lista_lojas:
			lista_cores.append(loja[0])
			lista_urls.append(loja[1].strip_edges())
			lista_lojas_precos_vazios.append([0])
		nomes_produtos.append(LineEditNomeDoProduto.text.strip_edges())
		tags_produtos.append(textoTagsParaLista(LineEditTagsDoProduto.text))
		cor_lojas_produtos.append(lista_cores)
		url_lojas_produtos.append(lista_urls)
		data_lojas_produtos.append([hoje])
		preco_lojas_produtos.append(lista_lojas_precos_vazios)
		indice_produto = len(nomes_produtos) - 1
		ControlJanelaProduto.set_meta('indice_produto', indice_produto)
		LabelNomeDoProduto.text = nomes_produtos[indice_produto]
		LabelTagsDoProduto.text = listaTagsParaTexto(tags_produtos[indice_produto])
		OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.select(0)
		OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.select(0)
		carregarPrecosPorLoja()
		gerarGraficoHistoricoDePrecos()
		filtrarProdutosPorNomeETags()
		ControlJanelaProduto.visible = true

# Funcoes Janela Edicao
func cancelarEdicao():
	ControlJanelaAdicaoEdicao.visible = false
	ControlJanelaProduto.visible = true

func confirmarEdicao():
	var lista_precos_vazios = []
	var lista_cores = []
	var lista_urls = []
	var lista_datas_precos = []
	var lista_lojas = ScrollContainerURLECorDasLojas.get_meta('lista_lojas')
	var remover_loja_antiga = ScrollContainerURLECorDasLojas.get_meta('remover_loja_antiga')
	var indice_produto = ControlJanelaProduto.get_meta('indice_produto')
	var indice_remover = len(remover_loja_antiga) - 1
	var hoje = Time.get_date_dict_from_system()
	erroAdicaoOuEdicao()
	if not AcceptDialogErrosDaAdicaoOuEdicao.visible:
		ControlJanelaAdicaoEdicao.visible = false
		while indice_remover >= 0:
			if remover_loja_antiga[indice_remover]:
				url_lojas_produtos[indice_produto].pop_at(indice_remover)
				cor_lojas_produtos[indice_produto].pop_at(indice_remover)
				preco_lojas_produtos[indice_produto].pop_at(indice_remover)
			indice_remover -= 1
		for loja in lista_lojas:
			lista_cores.append(loja[0])
			lista_urls.append(loja[1].strip_edges())
		nomes_produtos[indice_produto] = LineEditNomeDoProduto.text.strip_edges()
		tags_produtos[indice_produto] = textoTagsParaLista(LineEditTagsDoProduto.text)
		cor_lojas_produtos[indice_produto] = lista_cores
		url_lojas_produtos[indice_produto] = lista_urls
		if hoje not in data_lojas_produtos[indice_produto]:
			data_lojas_produtos[indice_produto].append(hoje)
			for loja in preco_lojas_produtos[indice_produto]:
				loja.append(0)
		for data in data_lojas_produtos[indice_produto]:
			lista_precos_vazios.append(0)
		while len(lista_lojas) != len(preco_lojas_produtos[indice_produto]) and len(lista_lojas) >= len(preco_lojas_produtos[indice_produto]):
			preco_lojas_produtos[indice_produto].append(lista_precos_vazios)
		lista_datas_precos = removerDatasNaoUtilizadas(data_lojas_produtos[indice_produto], preco_lojas_produtos[indice_produto])
		data_lojas_produtos[indice_produto] = lista_datas_precos[0]
		preco_lojas_produtos[indice_produto] = lista_datas_precos[1]
		LabelNomeDoProduto.text = nomes_produtos[indice_produto]
		LabelTagsDoProduto.text = listaTagsParaTexto(tags_produtos[indice_produto])
		OptionButtonIncluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos.select(0)
		OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.select(0)
		carregarPrecosPorLoja()
		gerarGraficoHistoricoDePrecos()
		filtrarProdutosPorNomeETags()
		ControlJanelaProduto.visible = true

# Funcoes Janela Produto
func incluirPrecosAtuaisPorLojaOuGraficoDoHistoricoDePrecos(opcao):
	match opcao:
		0:
			OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.visible = false
			ScrollContainerGraficoDoHistoricoDePrecos.visible = false
			ScrollContainerIncluirPrecosAtuaisPorLoja.visible = true
			ButtonIncluirPrecosAtuais.visible = true
		1:
			ScrollContainerIncluirPrecosAtuaisPorLoja.visible = false
			ButtonIncluirPrecosAtuais.visible = false
			OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.visible = true
			ScrollContainerGraficoDoHistoricoDePrecos.visible = true

func carregarPrecosPorLoja():
	var PanelLoja = null
	var LinkButtonPaginaDoProdutoDaLoja = null
	var LineEditPrecoDoProdutoDaLoja = null
	var indice_produto = ControlJanelaProduto.get_meta('indice_produto')
	var indice_loja = 0
	
	for panel_loja in VBoxContainerIncluirPrecosAtuaisPorLoja.get_children():
		panel_loja.queue_free()
	
	while indice_loja < len(url_lojas_produtos[indice_produto]):
		PanelLoja = Panel.new()
		LinkButtonPaginaDoProdutoDaLoja = LinkButton.new()
		LineEditPrecoDoProdutoDaLoja = LineEdit.new()
		
		PanelLoja.custom_minimum_size = Vector2(600, 80)
		VBoxContainerIncluirPrecosAtuaisPorLoja.add_child(PanelLoja)
		
		LinkButtonPaginaDoProdutoDaLoja.text = hostLoja(url_lojas_produtos[indice_produto][indice_loja])
		LinkButtonPaginaDoProdutoDaLoja.uri = url_lojas_produtos[indice_produto][indice_loja]
		LinkButtonPaginaDoProdutoDaLoja.custom_minimum_size = Vector2(380, 40)
		LinkButtonPaginaDoProdutoDaLoja.tooltip_text = 'Clique para ir à Página da Loja.'
		PanelLoja.add_child(LinkButtonPaginaDoProdutoDaLoja)
		
		LineEditPrecoDoProdutoDaLoja.text = ''
		LineEditPrecoDoProdutoDaLoja.placeholder_text = 'Preço da Loja'
		LineEditPrecoDoProdutoDaLoja.custom_minimum_size = Vector2(160, 40)
		LineEditPrecoDoProdutoDaLoja.tooltip_text = 'Insira o Preço Atual dessa Loja.'
		LineEditPrecoDoProdutoDaLoja.connect('text_changed', Callable(self, 'apenasNumero').bind(indice_loja))
		PanelLoja.add_child(LineEditPrecoDoProdutoDaLoja)
		
		indice_loja += 1

func apenasNumero(texto, indice_loja):
	var LineEditPrecoDoProdutoDaLoja = null
	var texto_numero = ''
	for letra in texto:
		match letra:
			'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.':
				texto_numero += letra
	LineEditPrecoDoProdutoDaLoja = VBoxContainerIncluirPrecosAtuaisPorLoja.get_child(indice_loja).get_child(1)
	LineEditPrecoDoProdutoDaLoja.text = texto_numero
	LineEditPrecoDoProdutoDaLoja.caret_column = len(texto_numero)

func incluirPrecosAtuais():
	var indice_produto = ControlJanelaProduto.get_meta('indice_produto')
	var precos_incluir = []
	var ja_adicionado_hoje = false
	var indice_loja = 0
	var hoje = Time.get_date_dict_from_system()
	erroInsercaoPrecosAtuais()
	if not AcceptDialogErrosDeIncluirPrecosAtuais.visible:
		if hoje in data_lojas_produtos[indice_produto]:
			ja_adicionado_hoje = true
		else:
			data_lojas_produtos[indice_produto].append(hoje)
		
		for PanelLoja in VBoxContainerIncluirPrecosAtuaisPorLoja.get_children():
			if PanelLoja.get_child(1).text == '':
				precos_incluir.append(0)
			else:
				precos_incluir.append(converterTextoParaNumero(PanelLoja.get_child(1).text))
		
		while indice_loja < len(precos_incluir):
			if ja_adicionado_hoje:
				preco_lojas_produtos[indice_produto][indice_loja][-1] = precos_incluir[indice_loja]
			else:
				preco_lojas_produtos[indice_produto][indice_loja].append(precos_incluir[indice_loja])
			indice_loja += 1
	gerarGraficoHistoricoDePrecos()
	filtrarProdutosPorNomeETags()

func gerarGraficoHistoricoDePrecos(opcao = 0):
	var PanelHistoricoDePrecos = null
	var LabelData = null
	var LabelSettingsLojaEPreco = null
	var LabelSettingsSemPreco = null
	var ColorRectPreco = null
	var LabelLoja = null
	var LabelPreco = null
	var LabelSemPreco = null
	var cor_loja = null
	var indice_produto = ControlJanelaProduto.get_meta('indice_produto')
	var datas_periodos = []
	var precos_periodos = []
	var maior_preco = 0.0
	var indice_loja = 0
	var indice_data = 0
	opcao = OptionButtonGraficoDoHistoricoDePrecosPorPeriodo.selected
	
	match opcao:
		0: # por dia
			datas_periodos = datasPeriodo(data_lojas_produtos[indice_produto])
			precos_periodos = precosPeriodo(data_lojas_produtos[indice_produto], preco_lojas_produtos[indice_produto])
		1: # por mes
			datas_periodos = datasPeriodo(data_lojas_produtos[indice_produto], 'm')
			precos_periodos = precosPeriodo(data_lojas_produtos[indice_produto], preco_lojas_produtos[indice_produto], 'm')
		2: # por ano
			datas_periodos = datasPeriodo(data_lojas_produtos[indice_produto], 'a')
			precos_periodos = precosPeriodo(data_lojas_produtos[indice_produto], preco_lojas_produtos[indice_produto], 'a')
	
	for precos_loja in precos_periodos:
		for preco in precos_loja:
			if preco > maior_preco:
				maior_preco = float(preco)
	ScrollContainerGraficoDoHistoricoDePrecos.set_meta('maior_preco', maior_preco)
	
	for panel_historioco_de_precos in VBoxContainerGraficoDoHistoricoDePrecos.get_children():
		panel_historioco_de_precos.queue_free()
	
	while indice_data < len(datas_periodos):
		indice_loja = 0
		
		PanelHistoricoDePrecos = Panel.new()
		LabelData = Label.new()
		
		PanelHistoricoDePrecos.custom_minimum_size = Vector2(600, 100)
		VBoxContainerGraficoDoHistoricoDePrecos.add_child(PanelHistoricoDePrecos)
		
		LabelData.text = datas_periodos[indice_data]
		LabelData.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		LabelData.clip_text = true
		LabelData.custom_minimum_size = Vector2(560, 30)
		LabelData.tooltip_text = 'Data dos Preços exibidos.'
		PanelHistoricoDePrecos.add_child(LabelData)
		
		while indice_loja < len(precos_periodos):
			cor_loja = cor_lojas_produtos[indice_produto][indice_loja]
			if (float(precos_periodos[indice_loja][indice_data]) / maior_preco) > 0:
				ColorRectPreco = ColorRect.new()
				LabelSettingsLojaEPreco = LabelSettings.new()
				LabelLoja = Label.new()
				LabelPreco = Label.new()
				
				ColorRectPreco.color = cor_loja
				ColorRectPreco.custom_minimum_size = Vector2(0, 30)
				PanelHistoricoDePrecos.add_child(ColorRectPreco)
				
				if cor_loja.get_luminance() < 0.5:
					LabelSettingsLojaEPreco.font_color = Color(0, 0, 0, 1)
				LabelSettingsLojaEPreco.outline_size = 4
				LabelSettingsLojaEPreco.outline_color = cor_loja.inverted()
				LabelSettingsLojaEPreco.shadow_size = 0
				LabelSettingsLojaEPreco.shadow_offset = Vector2(0, 0)
				
				LabelLoja.text = hostLoja(url_lojas_produtos[indice_produto][indice_loja])
				LabelLoja.label_settings = LabelSettingsLojaEPreco
				LabelLoja.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				LabelLoja.clip_text = true
				LabelLoja.custom_minimum_size = Vector2(0, 0)
				ColorRectPreco.add_child(LabelLoja)
				
				LabelPreco.text = '$' + str(precos_periodos[indice_loja][indice_data])
				LabelPreco.label_settings = LabelSettingsLojaEPreco
				LabelPreco.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				LabelPreco.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				LabelPreco.clip_text = true
				LabelPreco.custom_minimum_size = Vector2(0, 30)
				ColorRectPreco.add_child(LabelPreco)
			else:
				LabelSettingsSemPreco = LabelSettings.new()
				LabelSemPreco = Label.new()
				
				LabelSettingsSemPreco.font_color = cor_loja
				LabelSettingsSemPreco.outline_size = 4
				if not cor_loja.get_luminance() < 0.5:
					LabelSettingsSemPreco.outline_color = Color(0, 0, 0, 1)
				LabelSettingsSemPreco.shadow_size = 0
				LabelSettingsSemPreco.shadow_offset = Vector2(0, 0)
				
				LabelSemPreco.text = 'Para a Loja \"' + hostLoja(url_lojas_produtos[indice_produto][indice_loja]) + '\" não tem Preço registrado nessa Data'
				LabelSemPreco.label_settings = LabelSettingsSemPreco
				LabelSemPreco.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				LabelSemPreco.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				LabelSemPreco.clip_text = true
				LabelSemPreco.custom_minimum_size = Vector2(560, 30)
				PanelHistoricoDePrecos.add_child(LabelSemPreco)
			indice_loja += 1
		indice_data += 1
	redimensionamentoInterface()

func voltarParaJanelaInicial():
	ControlJanelaProduto.visible = false
	ControlJanelaInicial.visible = true

func possivelmenteEditarProduto():
	var indice_loja = 0
	var lista_lojas = []
	var remover_loja_antiga = []
	var indice_produto = ControlJanelaProduto.get_meta('indice_produto')
	ControlJanelaProduto.visible = false
	LineEditNomeDoProduto.text = nomes_produtos[indice_produto]
	LineEditTagsDoProduto.text = listaTagsParaTexto(tags_produtos[indice_produto])
	while indice_loja < len(url_lojas_produtos[indice_produto]):
		lista_lojas.append([cor_lojas_produtos[indice_produto][indice_loja], url_lojas_produtos[indice_produto][indice_loja], indice_loja])
		remover_loja_antiga.append(false)
		indice_loja += 1
	ScrollContainerURLECorDasLojas.set_meta('janela_adicao', false)
	ScrollContainerURLECorDasLojas.set_meta('lista_lojas', lista_lojas)
	ScrollContainerURLECorDasLojas.set_meta('remover_loja_antiga', remover_loja_antiga)
	ButtonCancelarAdicaoOuEdicao.text = 'Cancelar Edicao'
	if ButtonCancelarAdicaoOuEdicao.is_connected('pressed', Callable(self, 'cancelarAdicao')):
		ButtonCancelarAdicaoOuEdicao.disconnect('pressed', Callable(self, 'cancelarAdicao'))
	ButtonCancelarAdicaoOuEdicao.tooltip_text = 'Clique para Cancelar a Edição do Produto e Voltar à Página do mesmo.'
	ButtonCancelarAdicaoOuEdicao.connect('pressed', Callable(self, 'cancelarEdicao'))
	ButtonConfirmarAdicaoOuEdicao.text = 'Confirmar Edicao'
	if ButtonConfirmarAdicaoOuEdicao.is_connected('pressed', Callable(self, 'confirmarAdicao')):
		ButtonConfirmarAdicaoOuEdicao.disconnect('pressed', Callable(self, 'confirmarAdicao'))
	ButtonConfirmarAdicaoOuEdicao.tooltip_text = 'Clique para Confirmar a Edição do Produto e ir à sua Página.'
	ButtonConfirmarAdicaoOuEdicao.connect('pressed', Callable(self, 'confirmarEdicao'))
	AcceptDialogErrosDaAdicaoOuEdicao.title = 'Erro(s) na Edição do Produto'
	atualizarPainelDeLojas()
	ControlJanelaAdicaoEdicao.visible = true

func erroInsercaoPrecosAtuais():
	var tamanho_x = round(get_window().size.x * 0.25)
	var texto_numero = ''
	var tem_erro = null
	
	for PanelLoja in VBoxContainerIncluirPrecosAtuaisPorLoja.get_children():
		texto_numero = PanelLoja.get_child(1).text
		if texto_numero == '':
			texto_numero = '0'
		tem_erro = str(converterTextoParaNumero(texto_numero))
		if tem_erro == 'erro':
			AcceptDialogErrosDeIncluirPrecosAtuais.dialog_text = 'O número do Preço de uma ou mais lojas não pode ser processado devido a um erro de divisor decimal!'
			AcceptDialogErrosDeIncluirPrecosAtuais.size = Vector2(tamanho_x, 0)
			AcceptDialogErrosDeIncluirPrecosAtuais.visible = true
