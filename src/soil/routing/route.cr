module Soil
  class Route
    getter method : String
    getter path : String
    getter callables = [] of Handler

    def initialize(@method, @path)
      @reader = Char::Reader.new(@path)
    end

    def initialize(@method, @path, callables)
      @callables += callables
      @reader = Char::Reader.new(@path)
    end

    def matches?(request)
      matches_method?(request) && matches_path?(request)
    end

    def call(request, response)
      @callables.each do |callable|
        return if response.halted?
        callable.call(request, response)
      end
    end

    private def build_reader(path)
      Char::Reader.new(path)
    end

    private def matches_method?(request)
      request.method.downcase == @method.downcase
    end

    private def advance_to(reader, char)
      while reader.has_next? && reader.current_char != char
        yield reader.current_char
        reader.next_char
      end
    end

    private def matches_path?(request)
      return true if matches_exactly?(request.path)

      @reader.pos = 0

      path_reader = Char::Reader.new(request.path)

      while path_reader.has_next?

        # Char is equal
        if @reader.current_char == path_reader.current_char
          @reader.next_char
          path_reader.next_char
          next

        # @reader reached the end
        elsif !@reader.has_next? && path_reader.has_next?
          path_reader.next_char
          return true if url_params?(path_reader)
          return true if trailing_slash?(path_reader)
          return true if trailing_slash_with_url_params?(path_reader)
          return false

        # Named parameter
        elsif @reader.current_char == ':'
          @reader.next_char

          param_name = String.build do |str|
            while @reader.has_next? && !terminal?(@reader.current_char)
              str << @reader.current_char
              @reader.next_char
            end
          end

          param = String.build do |str|
            while path_reader.has_next? && !terminal?(path_reader.current_char)
              str << path_reader.current_char
              path_reader.next_char
            end
          end

          request.params.url[param_name] = param

          # Named parameter is in the end of the path
          if !@reader.has_next? && !path_reader.has_next?
            return true
          end

        # Didnt match any rules
        else
          return false
        end
      end

      # Both @reader and path_reader reached the end
      return true if !@reader.has_next? && !path_reader.has_next?

      # Default result is false
      false
    end

    private def terminal?(char)
      char == '/' || char == '?' || char == '\0'
    end

    private def trailing_slash_with_url_params?(reader)
      trailing_slash?(reader) &&
        reader.has_next? &&
        reader.peek_next_char == '?'
    end

    private def url_params?(reader)
      reader.current_char == '?'
    end

    private def trailing_slash?(reader)
      reader.current_char == '/' && !reader.has_next?
    end

    private def matches_exactly?(path)
      path.chomp("/") == @path
    end
  end
end
