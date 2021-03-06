# encoding: utf-8
module GpArticle::Model::Rel::Doc::Rel
  attr_accessor :in_rel_doc_ids

  def rel_docs
    docs = []
    ids = rel_doc_ids.to_s.split(' ').uniq
    return docs if ids.size == 0
    ids.each do |id|
      doc = GpArticle::Doc.find_by_id(id)
      doc ||= GpArticle::Doc.find_by_name_and_state(id, 'public')
      docs << doc if doc
    end
    docs
  end

  def in_rel_doc_ids
    unless val = read_attribute(:in_rel_doc_ids)
      write_attribute(:in_rel_doc_ids, rel_doc_ids.to_s.split(' ').uniq)
    end
    read_attribute(:in_rel_doc_ids)
  end

  def in_rel_doc_ids=(ids)
    _ids = []
    if ids.class == Array
      ids.each {|val| _ids << GpArticle::Doc.find_by_id(val).try(:name) || val}
      write_attribute(:rel_doc_ids, _ids.join(' '))
    elsif ids.class == Hash || ids.class == HashWithIndifferentAccess
      ids.each {|key, val| _ids << GpArticle::Doc.find_by_id(val).try(:name) || val}
      write_attribute(:rel_doc_ids, _ids.join(' '))
    elsif ids.kind_of?(String)
      _ids = ids.split(' ').map{|id| GpArticle::Doc.find_by_id(id).try(:name) || id }.uniq
      write_attribute(:rel_doc_ids, _ids.join(' '))
    else
      write_attribute(:rel_doc_ids, ids)
    end
  end
end
