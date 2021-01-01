class CodeGeneratorService
  def self.generate(len)
    [*('a'..'z'), *('0'..'9'), *('A'..'Z')].shuffle[0, len].join
  end
end
