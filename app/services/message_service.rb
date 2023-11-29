class MessageService
  def initialize; end

  def reservation_status_update(reservation)
    messages = { 'confirmed': "Sua reserva foi realizada. Em breve, a #{reservation.room.inn.brand_name} entrará em contato com você.",
                 'canceled': 'Poxa, que pena que teve que cancelar. Conte com a gente na sua próxima viagem.',
                 'active': 'Check-in realizado.',
                 'closing': 'Preparando check-out',
                 'closed': 'Check-out realizado.',
                 'rated': 'Sua avaliação foi recebida. Obrigado!',
                 'answered': 'Sua resposta foi recebida. Obrigado!' }
    messages[reservation.status.to_sym]
  end
end
