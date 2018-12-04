require_relative 'caixa'

#Aquecimento 01 - Projeto Casa de Câmbio via Terminal

def menu()
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
def abre_caixa()
  puts 'Bem-vindo à Casa de Câmbio!'
  puts 'Insira a cotação atual do dólar (em reais): '
  cotacao = gets.to_f
  puts 'Insira o montante de DÓLARES disponíveis: '
  dolares = gets.to_f
  puts 'Insira o montante de REAIS disponíveis: '
  reais = gets.to_f
  Caixa.new(cotacao, dolares, reais)
end

caixa = abre_caixa()
opcao = menu()

while opcao != 7 
  if opcao == 1
    puts 'Insira o valor desejado (em dólares): '
    valor = gets.to_f
    caixa.compra_dolares(valor)
  elsif opcao == 2
    puts 'Insira o valor desejado (em dólares): '
    valor = gets.to_f
    caixa.vende_dolares(valor)
  elsif opcao == 3
    puts 'Insira o valor desejado (em reais): '
    valor = gets.to_f
    caixa.compra_reais(valor)
  elsif opcao == 4
    puts 'Insira o valor desejado (em reais): '
    valor = gets.to_f
    caixa.vende_reais(valor)
  elsif opcao == 5
    caixa.imprime_transacoes
  elsif opcao == 6
    caixa.to_s
  else
    puts
    puts 'Opção inválida!'
  end
  opcao = menu()
end

