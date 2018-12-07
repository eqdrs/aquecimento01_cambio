require_relative 'caixa'
require "sqlite3"

#Aquecimento 01 - Projeto Casa de Câmbio via Terminal

def menu
  puts
  puts 'Escolha uma opção no menu:'
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

#Operação para abrir o caixa
def abre_caixa
  puts 'Bem-vindo à Casa de Câmbio!'
  print 'Insira a cotação atual do dólar (em reais): '
  cotacao = gets.to_f
  print 'Insira o montante de DÓLARES disponíveis: $ '
  dolares = gets.to_f
  print 'Insira o montante de REAIS disponíveis: R$ '
  reais = gets.to_f
  Caixa.new(cotacao: cotacao, dolares: dolares, reais: reais)
end

#Carrega histórico de transações ao iniciar sistema, caso o usuário deseje
def carrega_transacoes(caixa)
  loop do
    puts 'Carregar histórico de transações? (s/n)'
    resposta = gets.chomp
    (resposta == 's') && (caixa.carrega_transacoes) && (return) or
    (resposta == 'n') && (return) or
    puts 'Resposta inválida!' 
  end
end

caixa = abre_caixa
carrega_transacoes(caixa)
opcao = menu

while opcao != 7 
  if opcao == 1
    print 'Insira o valor desejado (em dólares): $ '
    valor = gets.to_f
    caixa.compra_dolares(valor)
  elsif opcao == 2
    print 'Insira o valor desejado (em dólares): $ '
    valor = gets.to_f
    caixa.vende_dolares(valor)
  elsif opcao == 3
    print 'Insira o valor desejado (em reais): R$ '
    valor = gets.to_f
    caixa.compra_reais(valor)
  elsif opcao == 4
    print 'Insira o valor desejado (em reais): R$'
    valor = gets.to_f
    caixa.vende_reais(valor)
  elsif opcao == 5
    caixa.imprime_transacoes
  elsif opcao == 6
    puts caixa
  else
    puts
    puts 'Opção inválida!'
  end
  opcao = menu
end

