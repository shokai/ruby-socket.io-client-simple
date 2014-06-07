require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestSocketIOClientSimple < MiniTest::Test

  def setup
    TestServer.start
  end

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

    post_data = {"msg" => "hello", "at" => Time.now.to_s}
    socket.on :connect do
      socket.emit :chat, post_data
    end

    sleep 0.5
    assert_equal post_data, result
  end

  def test_connect_with_query_parameter
    socket = SocketIO::Client::Simple.connect "#{TestServer.url}/?app=appid"
    result = false
    socket.on :connect do
      result = true
    end
    sleep 0.5
    assert result
  end

end
