class Transacao
  attr_accessor :id, :tipo, :moeda, :cotacao, :total

  def initialize(id:, tipo:, moeda:, cotacao:, total:)
    @id = id
    @tipo = tipo
    @moeda = moeda
    @cotacao = format("%.2f", cotacao)
    @total = format("%.2f", total)
  end
  
  def to_s()
    "\nTipo de operação: #{@tipo}\n"\
    "Moeda: #{@moeda}\n"\
    "Cotação: 1 dólar = #{@cotacao} reais\n"\
    "Total da transação: #{@total} dólares"
  end
  
  def attributes
    instance_variables.map{|ivar| instance_variable_get ivar}
  end

  def self.to_real(valor, cotacao)
    valor * cotacao
  end
  
  def self.to_dolar(valor, cotacao)
    valor / cotacao
  end
  
  #Imprime transacao no formato para ser salvo em arquivo, separado por ;
  def imprime()
    "#{@id};#{@tipo};#{@moeda};#{@cotacao};#{@total}\n"
  end
end
