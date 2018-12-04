require_relative 'transacao'
require 'terminal-table'

class Caixa
  attr_accessor :cotacao, :dolares, :reais
  
  def initialize(cotacao, dolares, reais)
    @cotacao = cotacao
	@dolares = dolares
	@reais = reais
	@transacoes = []
  end
  
  def compra_dolares(valor)
    if valor > Transacao.to_dolar(@reais, @cotacao)
	  puts "\nNão foi possível realizar a operação! Você não possui reais o suficiente!"
	elsif confirma_transacao(valor, 'dólares')
	  @dolares += valor
	  @reais -= Transacao.to_real(valor, @cotacao)
	  transacao = Transacao.new('Compra', 'Dolar', @cotacao, valor)
      realiza_transacao(transacao)
	else
	  puts 'Operação cancelada pelo usuário!'
	end
  end
  
  def vende_dolares(valor)
    if valor > @dolares
	  puts "\nNão foi possível realizar a operação! Você não possui dólares o suficiente!"
	elsif confirma_transacao(valor, 'dólares')
	  @dolares -= valor
	  @reais += Transacao.to_real(valor, @cotacao)
	  transacao = Transacao.new('Venda', 'Dolar', @cotacao, valor)
      realiza_transacao(transacao)
	else
	  puts 'Operação cancelada pelo usuário!'
	end
  end
  
  def compra_reais(valor)
    if valor > Transacao.to_real(@dolares, @cotacao)
	  puts "\nNão foi possível realizar a operação! Você não possui dólares o suficiente!"
	elsif confirma_transacao(valor, 'reais')
	  @reais += valor
	  @dolares -= Transacao.to_dolar(valor, @cotacao)
	  transacao = Transacao.new('Compra', 'Real', @cotacao, Transacao.to_dolar(valor, @cotacao))
	  realiza_transacao(transacao)
	else
	  puts 'Operação cancelada pelo usuário!'
	end
  end
  
  def vende_reais(valor)
    if valor > @reais
	  puts "\nNão foi possível realizar a operação! Você não possui reais o suficiente!"
	elsif confirma_transacao(valor, 'reais')
	  @reais -= valor
	  @dolares += Transacao.to_dolar(valor, @cotacao)
	  transacao = Transacao.new('Venda', 'Real', @cotacao, Transacao.to_dolar(valor, @cotacao))
	  realiza_transacao(transacao)
	else
	  puts 'Operação cancelada pelo usuário!'
	end
  end
  
  def confirma_transacao(valor, moeda)
    puts "\nValor total da transação:" 
	puts "#{format("%.2f", valor)} #{moeda}"
	(moeda == 'dólares') && (puts "#{format("%.2f", Transacao.to_real(valor, @cotacao))} reais") or
	(moeda == 'reais') && (puts "#{format("%.2f", Transacao.to_dolar(valor, @cotacao))} dólares")
	
	loop do
      puts "\nConfirma transação? (s/n)"
      resposta = gets().chomp
      (resposta == 's') && (return true) or
      (resposta == 'n') && (return false) or
	  puts 'Resposta inválida!'	
	end
  end

  def realiza_transacao(transacao)
      @transacoes << transacao
      puts 'Operação realizada com sucesso!'
      transacao.to_s 
  end
  
  #Imprime no terminal informações atualizadas sobre o caixa
  def to_s()
    puts
    puts "Cotação do dia: 1 dólar = #{format("%.2f", @cotacao)} reais"
	puts "Dólares disponíveis: #{format("%.2f", @dolares)} dólares"
	puts "Reais disponíveis: #{format("%.2f", @reais)} reais"
  end
  
  #Imprime lista de transações já realizadas
  def imprime_transacoes()
    rows = []
    @transacoes.each do |transacao|
	  rows << transacao.attributes
	end
	table = Terminal::Table.new :title => "Transações", :headings => ['Tipo', 'Moeda', 'Cotação do dia', 'Total da transação (em dólar)'], :rows => rows
	table.align_column(2, :right)
	table.align_column(3, :right)
	puts table
  end
end