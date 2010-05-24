require 'mkmf'

def have_libvirt_funcs(funcs)
    funcs.each { |f| have_func(f, "libvirt/libvirt.h") }
end

def have_libvirt_types(types)
    types.each { |t| have_type(t, "libvirt/libvirt.h") }
end

extension_name = '_libvirt'

dir_config(extension_name)

unless pkg_config("libvirt")
    raise "libvirt not found"
end

libvirt_types = [ 'virNetworkPtr',
                  'virStoragePoolPtr',
                  'virStorageVolPtr' ]

libvirt_funcs = [ 'virStorageVolWipe',
                  'virStoragePoolIsActive',
                  'virStoragePoolIsPersistent',
                  'virConnectGetLibVersion',
                  'virConnectIsEncrypted',
                  'virConnectIsSecure',
                ]

have_libvirt_types(libvirt_types)
have_libvirt_funcs(libvirt_funcs)

create_header
create_makefile(extension_name)
