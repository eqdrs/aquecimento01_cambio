require_relative 'caixa'
# Aquecimento Online - Projeto Casa de Câmbio via Terminal + Banco de Dados

def menu
  puts
  puts '===== Escolha uma opção no menu: ====='
  puts '[1] Comprar dólares'
  puts '[2] Vender dólares'
  puts '[3] Comprar reais'
  puts '[4] Vender reais'
  puts '[5] Ver operações do dia'
  puts '[6] Ver situação do caixa'
  puts '[7] Sair' 
  puts
  print 'Opção escolhida: '  
  
  gets.to_i
end

def confirma?
  resposta = gets.chomp
  resposta == 's'
end

# Aguarda usuário pressionar a tecla 'Enter'
def aguarda_usuario
  print "\nPressione a tecla \'Enter\' para continuar. "
  gets
end

# Operação para abrir o caixa do dia
def abre_caixa
  puts '======== Bem-vindo à Casa de Câmbio! ========'
  print "\nDigite o nome do Operador: "
  nome_caixa = gets.chomp
  date = DateTime.now.strftime("%Y-%m-%d")
  db = SQLite3::Database.open 'cambio.db'
  db.results_as_hash = true
  ultimo_registro = db.get_first_row('SELECT * FROM cashiers ORDER BY id_caixa DESC LIMIT 1')
  result = db.get_first_row('SELECT * FROM cashiers WHERE date = ? AND  nome_caixa = ?', date, nome_caixa)
  db.close

  # Verifica último registro/ID de caixa
  ultimo_registro !=nil ? (proximo_id = ultimo_registro['id_caixa']+1) : (proximo_id = 1)

  # Verifica se já existe caixa do dia cadastrado no banco de dados
  if result != nil 
    puts "\nCaixa do dia já possui cadastro no banco de dados:"
    caixa = Caixa.new(id_caixa: result['id_caixa'], nome_caixa: result['nome_caixa'], date: result['date'], 
                      cotacao: result['cotacao'], dolares: result['dolares'], reais: result['reais'])
    puts caixa
    puts "Deseja atualizar as informações do caixa? (s/n)"
    confirma? && caixa.atualiza_caixa
 
  # Caso ainda não exista, cria novo caixa no banco de dados
  else
    print 'Insira a cotação atual do dólar (em reais): '
    cotacao = gets.to_f
    print 'Insira o montante de DÓLARES disponíveis: $ '
    dolares = gets.to_f
    print 'Insira o montante de REAIS disponíveis: R$ '
    reais = gets.to_f
    caixa = Caixa.new(id_caixa: proximo_id, nome_caixa: nome_caixa, date: date, 
                      cotacao: cotacao, dolares: dolares, reais: reais)
    caixa.salva_caixa
  end
  caixa
end

caixa = abre_caixa
opcao = menu

# Loop principal
while opcao != 7 
  if opcao == 1
    print 'Insira o valor desejado (em dólares): $ '
    valor = gets.to_f
    caixa.compra_dolares(valor)
    aguarda_usuario
  elsif opcao == 2
    print 'Insira o valor desejado (em dólares): $ '
    valor = gets.to_f
    caixa.vende_dolares(valor)
    aguarda_usuario
  elsif opcao == 3
    print 'Insira o valor desejado (em reais): R$ '
    valor = gets.to_f
    caixa.compra_reais(valor)
    aguarda_usuario
  elsif opcao == 4
    print 'Insira o valor desejado (em reais): R$'
    valor = gets.to_f
    caixa.vende_reais(valor)
    aguarda_usuario
  elsif opcao == 5
    Transacao.imprime_transacoes(caixa.id_caixa)
    aguarda_usuario
  elsif opcao == 6
    puts caixa
    aguarda_usuario
  else
    puts
    puts 'Opção inválida!'
  end
  opcao = menu
end

