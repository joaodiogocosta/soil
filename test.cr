require "benchmark"

str1 = "/api/v2/users/:user_id/posts"
str2 = "/api/v2/users/:user_id/posts"

def equality(a, b)
  a_split = a.split('/')
  b_split = b.split('/')

  a_split.each_with_index do |a_bit, idx|
    return true if b_split[idx] != a_bit
  end

  return false
end

str1_split = str1.split('/')

def equality_split(a_split, b)
  b_split = b.split('/')

  a_split.each_with_index do |a_bit, idx|
    return true if b_split[idx] != a_bit
  end

  return false
end

def readers(a, b)
  ar = Char::Reader.new(a)
  br = Char::Reader.new(b)

  while ar.has_next?
    if ar.current_char == '/'
      ar.next_char
      br.next_char
      next
    elsif ar.current_char != br.current_char
      return false
    end

    ar.next_char
    br.next_char
  end

  return true
end

Benchmark.ips do |x|
  x.report("equality") { 1000.times { equality(str1, str2) } }
  x.report("equality_split") { 1000.times { equality_split(str1_split, str2) } }
  x.report("readers") { 1000.times { readers(str1, str2) }  }
end
