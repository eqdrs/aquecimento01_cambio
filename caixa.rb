require_relative 'transacao'
require 'terminal-table'
require "sqlite3"

class Caixa
  attr_accessor :cotacao, :dolares, :reais, :transacoes
  
  def initialize(cotacao:, dolares:, reais:)
    @cotacao = cotacao
    @dolares = dolares
    @reais = reais
    @transacoes = []
  end
  
  def compra_dolares(valor)
    if valor > Transacao.to_dolar(@reais, @cotacao)
      puts "\nNão foi possível realizar a operação! Você não possui reais o suficiente!"
    elsif confirma_transacao?(valor, 'dólares')
      @dolares += valor
      @reais -= Transacao.to_real(valor, @cotacao)
      transacao = Transacao.new(id: @transacoes.length+1, tipo: 'Compra', 
                                moeda: 'Dolar', cotacao: @cotacao, total: valor)
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def vende_dolares(valor)
    if valor > @dolares
      puts "\nNão foi possível realizar a operação! Você não possui dólares o suficiente!"
    elsif confirma_transacao?(valor, 'dólares')
      @dolares -= valor
      @reais += Transacao.to_real(valor, @cotacao)
      transacao = Transacao.new(id: @transacoes.length+1, tipo: 'Venda', 
                                moeda: 'Dolar', cotacao: @cotacao, total: valor)
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def compra_reais(valor)
    if valor > Transacao.to_real(@dolares, @cotacao)
      puts "\nNão foi possível realizar a operação! Você não possui dólares o suficiente!"
    elsif confirma_transacao?(valor, 'reais')
      @reais += valor
      @dolares -= Transacao.to_dolar(valor, @cotacao)
      transacao = Transacao.new(id: @transacoes.length+1, tipo: 'Compra', moeda: 'Real', 
                                cotacao: @cotacao, total: Transacao.to_dolar(valor, @cotacao))
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def vende_reais(valor)
    if valor > @reais
      puts "\nNão foi possível realizar a operação! Você não possui reais o suficiente!"
    elsif confirma_transacao?(valor, 'reais')
      @reais -= valor
      @dolares += Transacao.to_dolar(valor, @cotacao)
      transacao = Transacao.new(id: @transacoes.length+1, tipo: 'Venda', moeda: 'Real', 
                                cotacao: @cotacao, total: Transacao.to_dolar(valor, @cotacao))
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def confirma_transacao?(valor, moeda)
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
    salva_transacoes(transacao)
    puts 'Operação realizada com sucesso!'
    puts transacao 
  end
  
  #Imprime no terminal informações atualizadas sobre o caixa
  def to_s
    rows = []
    rows << ['Cotação do dia', "1 dólar = #{format("%.2f", @cotacao)} reais"]
    rows << ['Dólares disponíveis', "$ #{format("%.2f", @dolares)}"]
    rows << ['Reais disponíveis', "R$ #{format("%.2f", @reais)}"]
    table = Terminal::Table.new :title => "Informações sobre o caixa", :rows => rows
    table.to_s
  end
  
  #Busca as transações no banco de dados e as impreme usando a gem terminal-table 
  def imprime_transacoes
    rows = []
    db = SQLite3::Database.open 'cambio.db'
    db.execute( "select * from transactions" ) do |row|
      rows << row
    end
    db.close
    table = Terminal::Table.new :title => "Transações", :headings => ['ID', 'Tipo', 'Moeda', 'Cotação (R$)', 'Total da transação ($)'], :rows => rows
    table.align_column(3, :right)
    table.align_column(4, :right)
    puts table
  end

  #Salva transação no banco de dados
  def salva_transacoes(transacao)
    db = SQLite3::Database.open 'cambio.db'
    db.execute("INSERT INTO transactions (tipo,moeda,cotacao,total) VALUES (?,?,?,?) ", 
        transacao.tipo, 
        transacao.moeda, 
        transacao.cotacao, 
        transacao.total
    )
    db.close
  end
  
  #Carrega as transações do banco de dados ao iniciar o sistema
  def carrega_transacoes
    db = SQLite3::Database.open 'cambio.db'
    db.results_as_hash = true
    db.execute( "select * from transactions" ) do |row|
      @transacoes << Transacao.new(id: row['id'], tipo: row['tipo'], moeda: row['moeda'], 
                                  cotacao: row['cotacao'], total: row['total'])
    end
    db.close
    puts 'Transações carregadas com sucesso!'
    true   
  end

end