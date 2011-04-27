#encoding: utf-8
class InvoiceJob
  @queue = :invoice

  class << self
    def perform(user_id, *execution_ids)
      puts "processing user=#{user_id}, executions=#{execution_ids}"
      user = User.find(user_id)
      executions = execution_ids.map{|execution_id| Execution.find(execution_id)}
      invoice = Invoice.new(user: user, executions: executions)
      invoice.compute
      # doh!
      puts "invoicing #{user.greeter_name} : #{invoice.amount}"
      # post and get back xero InvoiceNumber
      xml = to_xml(invoice)
      require 'ruby-debug'; debugger
      node = post! xml
      invoice.ref = node.xpath('/Response/Invoices/Invoice/InvoiceNumber').first.content
      # save
      invoice.save!
    end

    private
    def erb
      @erb ||= XeroMin::Erb.new(File.expand_path('../xero/templates', __FILE__))
    end
    def client
      @client ||= XeroMin::Client.new
    end
    def to_xml(invoice)
      erb.render(invoice: invoice).tap{|xml| File.open("invoice-#{invoice.id}.xml", 'w'){|f| f << xml}}
    end
    def post!(xml)
      client.post!(:invoices, body: xml)
    end
  end
end