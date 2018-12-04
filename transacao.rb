class Transacao
  attr_accessor :tipo, :moeda, :cotacao, :total

  def initialize(tipo, moeda, cotacao, total)
    @tipo = tipo
	@moeda = moeda
	@cotacao = cotacao
	@total = total
  end
  
  def to_s()
    puts
    puts "Tipo da transação: #{@tipo}"
	puts "Moeda: #{@moeda}"
	puts "Cotação: 1 dólar = #{format("%.2f", @cotacao)} reais"
	puts "Total da transação: #{format("%.2f", @total)} dólares"
  end

  def self.to_real(valor, cotacao)
    valor * cotacao
  end
  
  def self.to_dolar(valor, cotacao)
    valor / cotacao
  end
end
