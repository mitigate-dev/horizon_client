require 'spec_helper'

RSpec.describe HorizonClient do
  let(:client) { HorizonClient.new }
  let(:path) { 'test' }

  context 'entity' do
    let(:xml) do
      <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <resource>
          <entity>
            <description>success</description>
            <PK>
              <href>entity/path</href>
            </PK>
          </entity>
        </resource>
      XML
    end

    before do
      stub_request(:get, horizon_url(client, path)).to_return(body: xml, status: 200, headers: { 'Content-Type': 'xml' })
    end

    it 'parses entity xml response' do
      entity = client.get(path).entity

      expect(entity['description']).to eq 'success'
      expect(entity['PK']).to eq 'entity/path'
    end
  end

  context 'result' do
    let(:xml) do
      <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <result>
          <link>
            <href>success/path</href>
          </link>
        </result>
      XML
    end

    before do
      stub_request(:get, horizon_url(client, path)).to_return(body: xml, status: 200, headers: { 'Content-Type': 'xml' })
    end

    it 'parses result xml response' do
      entity = client.get(path).result
      expect(entity['link']).to eq 'success/path'
    end
  end

  context 'collection' do
    let(:xml) do
      <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <resource>
          <collection>
            <row>
              <a>
                <name>entity 1</name>
                <PK>
                  <href>entity/1</href>
                </PK>
              </a>
            </row>
            <row>
              <a>
                <name>entity 2</name>
                <PK>
                  <href>entity/2</href>
                </PK>
              </a>
            </row>
          </collection>
        </resource>
      XML
    end

    before do
      stub_request(:get, horizon_url(client, path)).to_return(body: xml, status: 200, headers: { 'Content-Type': 'xml' })
    end

    it 'parses collection xml' do
      collection = client.get(path).collection

      expect(collection.rows.size).to eq 2

      row = collection.rows.first

      expect(row['a/name']).to eq 'entity 1'
      expect(row['a/PK']).to eq 'entity/1'
    end
  end

  context 'error handling' do
    before do
      xml = <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <error>
        	<message>Not found!</message>
        </error>
      XML

      stub_request(:get, horizon_url(client, path)).to_return(body: xml, status: 404, headers: { 'Content-Type': 'xml' })
    end

    it 'raises error with a message' do
      expect { client.get(path) }.to raise_error(HorizonClient::Response::ResourceError, 'Not found!')
    end
  end

  context 'url overrides' do
    let(:base) { 'http://hor.test' }
    let!(:client) { HorizonClient.new(base) }

    before do
      xml = <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <resource></resource>
      XML

      stub_request(:get, "#{base}/#{path}").to_return(body: '', status: 200, headers: { 'Content-Type': 'xml' })
    end

    it 'uses param url over environment parameter' do
      client.get(path)
      expect(WebMock).to have_requested(:get, horizon_url(client, path))
    end
  end

  context 'posts' do
    let(:xml) do
      <<-XML.strip
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <resource>
          <entity>
            <description>enitity 1</description>
            <empty_elem/>
            <PK>
              <href>entity/path</href>
            </PK>
          </entity>
        </resource>
      XML
    end

    let(:expected_xml) do
      <<-XML.strip.gsub(/\s+/, " ")
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <resource>
          <entity>
            <description>changed description</description>
            <empty_elem>not so empty</empty_elem>
            <PK>
              <href>other/path</href>
            </PK>
            <col>
              <row>
                <name>a name</name>
              </row>
              <row>
                <name>b name</name>
              </row>
            </col>
          </entity>
        </resource>
      XML
    end

    before do
      stub_request(:post, horizon_url(client, path)).to_return(body: '', status: 200, headers: { 'Content-Type': 'xml' })
    end

    it 'does posts' do
      resource = HorizonClient::Resource.new(xml)
      entity = resource.entity
      entity['description'] = 'changed description'
      entity['empty_elem'] = 'not so empty'
      entity['PK/href'] = 'other/path'

      collection = entity.get_collection('col')

      row_a = collection.build
      row_a['name'] = 'a name'
      row_b = collection.build
      row_b['name'] = 'b name'

      expect(Ox.dump(resource.document, with_xml: true).strip.gsub(/\s+/, " ")).to match(expected_xml)

      client.post(path, resource)
      expect(WebMock).to have_requested(:post, horizon_url(client, path))
    end
  end
end
