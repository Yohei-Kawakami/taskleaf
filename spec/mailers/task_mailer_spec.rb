require "rails_helper"

describe TaskMailer, type: :mailer do

  let(:task) { FactoryBot.create(:task, name: 'mailer spec', description:'confirm mail result') }

  let(:text_body) do
      part = mail.body.parts.detect { |part| part.content_type == 'text/plain; charset=UTF-8' }
      part.body.raw_source
  end

  let(:html_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/plain; charset=UTF-8' }
    part.body.raw_source
  end

  describe '#creation_email' do
    let(:mail) { TaskMailer.creation_email(task) }

    it 'successfully created' do
      # headder
      expect(mail.subject).to eq('Task Create Reminder')
      expect(mail.to).to eq(['user@example.com'])
      expect(mail.from).to eq(['taskleaf@example.com'])

      # text body
      expect(text_body).to match('Task is created below')
      expect(text_body).to match('mailer spec')
      expect(text_body).to match('confirm mail result')

      # html body
      expect(html_body).to match('Task is created below')
      expect(html_body).to match('mailer spec')
      expect(html_body).to match('confirm mail result')
    end
  end
end