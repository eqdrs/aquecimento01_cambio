require 'sqlite3'
require 'date'
require 'terminal-table'

class Transacao
  attr_accessor :tipo, :moeda, :cotacao, :total, :id_caixa

  def initialize(tipo:, moeda:, cotacao:, total:, id_caixa:)
    @tipo = tipo
    @moeda = moeda
    @cotacao = format("%.2f", cotacao)
    @total = format("%.2f", total)
    @id_caixa = id_caixa
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

  # Busca as transações do dia no banco de dados e as imprime usando a gem terminal-table 
  def self.imprime_transacoes(id_caixa)
    rows = []
    db = SQLite3::Database.open 'cambio.db'
    db.execute('SELECT * FROM transactions WHERE id_caixa == ?', id_caixa) do |row|
      row[3] = format("%.2f", row[3])
      row[4] = format("%.2f", row[4])
      rows << row
    end
    db.close
    table = Terminal::Table.new :title => 'Transações', :headings => ['ID', 'Tipo', 'Moeda', 'Cotação (R$)', 'Total da transação ($)', 'ID_Caixa'], :rows => rows
    table.align_column(3, :right)
    table.align_column(4, :right)
    table.align_column(5, :right)
    puts table
  end

  # Salva transação no banco de dados
  def salva_transacao
    db = SQLite3::Database.open 'cambio.db'
    db.execute('INSERT INTO transactions (tipo,moeda,cotacao,total,id_caixa) VALUES (?,?,?,?,?)', 
        @tipo, 
        @moeda, 
        @cotacao, 
        @total,
        @id_caixa
    )
    db.close
  end

end
