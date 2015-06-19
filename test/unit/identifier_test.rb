require 'unit_helper'

class IdentifierTest < UnitTestCase
  def test_generate_random_identifier_with_file_extension
    identifier_png = MountableFileServer::Identifier.generate_for filename: 'test.png', type: 'public'
    identifier_pdf = MountableFileServer::Identifier.generate_for filename: 'test.pdf', type: 'public'

    assert_match /\w+\.png$/, identifier_png
    assert_match /\w+\.pdf$/, identifier_pdf
  end

  def test_generate_random_identifier_with_type
    identifier_public = MountableFileServer::Identifier.generate_for filename: 'test.png', type: 'public'
    identifier_private = MountableFileServer::Identifier.generate_for filename: 'test.png', type: 'private'

    assert_match /^public-\w+/, identifier_public
    assert_match /^private-\w+/, identifier_private
  end

  def test_raise_error_for_unknown_types
    assert_raises(ArgumentError) { MountableFileServer::Identifier.generate_for(filename: 'test.png', type: 'unknow') }
    assert_raises(ArgumentError) { MountableFileServer::Identifier.new('random-test.png') }
  end

  def test_generate_returns_new_identifier
    assert_instance_of MountableFileServer::Identifier, MountableFileServer::Identifier.generate_for(filename: 'test.png', type: 'public')
  end

  def test_new_accepts_identifier_object
    MountableFileServer::Identifier.new MountableFileServer::Identifier.new('public-test.png')
  end

  def test_equality
    a = MountableFileServer::Identifier.new 'public-test.png'
    b = MountableFileServer::Identifier.new 'public-test.png'
    c = MountableFileServer::Identifier.new 'public-random.png'
    d = 'public-test.png'

    assert_equal a, b
    assert_equal a, d
    refute_equal a, c
  end

  def test_public?
    assert MountableFileServer::Identifier.new('public-test.png').public?
    refute MountableFileServer::Identifier.new('private-test.png').public?
  end
end