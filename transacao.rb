require 'sqlite3'
require 'date'
require 'terminal-table'

class Transacao
  attr_accessor :tipo, :moeda, :cotacao, :total

  def initialize(tipo:, moeda:, cotacao:, total:)
    @tipo = tipo
    @moeda = moeda
    @cotacao = format("%.2f", cotacao)
    @total = format("%.2f", total)
  end
  
  def to_s
    "\nTipo de operação: #{@tipo}\n"\
    "Moeda: #{@moeda}\n"\
    "Cotação: 1 dólar = #{@cotacao} reais\n"\
    "Total da transação: #{@total} dólares"
  end

  def self.to_real(valor, cotacao)
    valor * cotacao
  end
  
  def self.to_dolar(valor, cotacao)
    valor / cotacao
  end

  #Busca as transações do dia no banco de dados e as imprime usando a gem terminal-table 
  def self.imprime_transacoes
    rows = []
    db = SQLite3::Database.open 'cambio.db'
    db.execute( 'SELECT * FROM transactions') do |row|
      rows << row
    end
    db.close
    table = Terminal::Table.new :title => 'Transações', :headings => ['ID', 'Tipo', 'Moeda', 'Cotação (R$)', 'Total da transação ($)'], :rows => rows
    table.align_column(3, :right)
    table.align_column(4, :right)
    puts table
  end

  #Salva transação no banco de dados
  def salva_transacao
    db = SQLite3::Database.open 'cambio.db'
    db.execute('INSERT INTO transactions (tipo,moeda,cotacao,total) VALUES (?,?,?,?)', 
        @tipo, 
        @moeda, 
        @cotacao, 
        @total
    )
    db.close
  end

end
