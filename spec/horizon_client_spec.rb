require 'spec_helper'

RSpec.describe HorizonClient do
  let(:client) { HorizonClient.new }
  let(:get_path) { 'test' }
  let(:error_path) { 'error' }
  let(:post_path) { 'post' }

  before do
    xml = <<-XML
      <resource>
        <description>success</description>
      </resource>
    XML
    stub_request(:get, horizon_url(client, get_path)).to_return(body: xml, status: 200, headers: { 'Content-Type': 'xml' })
    stub_request(:post, horizon_url(client, post_path)).to_return(status: 200, body: '')
  end

  it 'parses xml response' do
    expect(client.get(get_path)).to match({'resource' => {'description' => 'success'}})
  end

  it 'does posts' do
    client.post('post', 'test')
    expect(WebMock).to have_requested(:post, horizon_url(client, post_path))
  end

  context 'error handling' do
    before do
      xml = <<-XML
        <error>
        	<class>ERestException</class>
        	<message>Ieraksts nav atrasts!</message>
        </error>
      XML

      stub_request(:get, horizon_url(client, error_path)).to_return(body: xml, status: 404, headers: { 'Content-Type': 'xml' })
    end

    it 'raises error with a message' do
      expect { client.get(error_path) }.to raise_error HorizonClient::ClientError
    end
  end

  context 'url overrides' do
    let!(:client) { HorizonClient.new(url: 'http://hor.test') }

    before do
      xml = <<-XML
        <resource>
          <description>different success</description>
        </resource>
      XML
      stub_request(:get, horizon_url(client, get_path)).to_return(body: xml, status: 200, headers: { 'Content-Type': 'xml' })
    end

    it 'uses param url over environment parameter' do
      expect(client.get(get_path)).to match({'resource' => {'description' => 'different success'}})
    end
  end
end
