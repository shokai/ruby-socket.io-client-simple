require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestSocketIOClientSimple < MiniTest::Test

  TestServer.start

  sleep 1

  def test_connect
    socket = SocketIO::Client::Simple.connect TestServer.url
    result = false
    socket.on :connect do
      result = true
    end
    sleep 0.5
    assert result
  end

  def test_emit_on
    socket = SocketIO::Client::Simple.connect TestServer.url
    result = nil
    socket.on :chat do |data|  ## receive echo
      result = data
    end

    post_data = {"msg" => "hello", "at" => Time.now.to_s, "あいさつ" => "こんにちは"}
    socket.on :connect do
      socket.emit :chat, post_data
    end

    sleep 0.5
    assert_equal post_data, result
  end

  def test_connect_with_query_parameter
    user = "hashimoto.shokai"
    socket = SocketIO::Client::Simple.connect TestServer.url, :user => user

    result = nil

    socket.on :chat do |data|
      result = data['user']
    end

    socket.on :connect do
      socket.emit :chat, {"msg" => "hello (query parameter test)", "at" => Time.now.to_s}
    end
    sleep 0.5

    assert_equal result, user
  end

  def test_disconnect
    socket = SocketIO::Client::Simple.connect TestServer.url

    socket.on :connect do
      socket.disconnect
    end
    sleep 0.5
    assert_equal socket.open?, false
  end
end
