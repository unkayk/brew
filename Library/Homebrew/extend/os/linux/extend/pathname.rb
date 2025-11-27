# typed: strict
# frozen_string_literal: true

require "os/linux/elf"

module ELFPathname
  sig { params(path: T.any(Pathname, String, ELFShim)).returns(ELFShim) }
  def self.wrap(path)
    return path if path.is_a?(ELFShim)

    path = ::Pathname.new(path)
    path.extend(ELFShim)
    T.cast(path, ELFShim)
  end
end

module BinaryPathname
  include ELFPathname
end

module OS
  module Linux
    module Pathname
      module ClassMethods
        extend T::Helpers

        requires_ancestor { T.class_of(::Pathname) }

        sig { void }
        def activate_extensions!
          super

          prepend(ELFShim)
        end
      end
    end
  end
end

Pathname.singleton_class.prepend(OS::Linux::Pathname::ClassMethods)
