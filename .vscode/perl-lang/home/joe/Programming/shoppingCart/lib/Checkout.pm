{"vars":[{"kind":12,"children":[{"definition":"my","line":8,"localvar":"my","containerName":"new","kind":13,"name":"$class"},{"name":"$products","containerName":"new","kind":13,"line":8},{"kind":13,"name":"$self","line":10,"definition":"my","containerName":"new","localvar":"my"},{"name":"get_item_code","containerName":"new","line":13,"kind":12},{"line":13,"kind":13,"containerName":"new","name":"$products"},{"line":18,"kind":13,"name":"$self","containerName":"new"},{"kind":13,"line":18,"containerName":"new","name":"$class"},{"containerName":"new","name":"$self","kind":13,"line":19}],"signature":{"label":"new($class,$products)","documentation":"","parameters":[{"label":"$class"},{"label":"$products"}]},"name":"new","detail":"($class,$products)","range":{"start":{"line":7,"character":0},"end":{"line":20,"character":9999}},"line":7,"definition":"sub","containerName":"main::"},{"line":8,"kind":2,"containerName":"","name":"JSON"},{"line":13,"kind":12,"name":"products"},{"line":14,"kind":12,"name":"subtotal"},{"name":"basket","line":15,"kind":12},{"signature":{"parameters":[{"label":"$self"},{"label":"$basket_items"}],"documentation":"","label":"add_basket_items($self,$basket_items)"},"name":"add_basket_items","detail":"($self,$basket_items)","kind":12,"children":[{"definition":"my","line":23,"localvar":"my","containerName":"add_basket_items","kind":13,"name":"$self"},{"name":"$basket_items","containerName":"add_basket_items","line":23,"kind":13},{"name":"$decoded_json","kind":13,"localvar":"my","containerName":"add_basket_items","definition":"my","line":25},{"containerName":"add_basket_items","name":"$basket_items","kind":13,"line":25},{"containerName":"add_basket_items","name":"$self","kind":13,"line":27},{"kind":13,"line":28,"name":"$self","containerName":"add_basket_items"},{"name":"$decoded_json","containerName":"add_basket_items","line":28,"kind":13},{"kind":13,"line":30,"containerName":"add_basket_items","name":"$self"},{"containerName":"add_basket_items","name":"_calculate_subtotal","kind":12,"line":30}],"containerName":"main::","range":{"start":{"character":0,"line":22},"end":{"line":32,"character":9999}},"line":22,"definition":"sub"},{"name":"decode_json","line":25,"kind":12},{"name":"subtotal","line":27,"kind":12},{"name":"basket","kind":12,"line":28},{"containerName":"main::","definition":"sub","range":{"start":{"character":0,"line":34},"end":{"line":37,"character":9999}},"line":34,"detail":"($self)","name":"get_subtotal","signature":{"parameters":[{"label":"$self"}],"documentation":"","label":"get_subtotal($self)"},"children":[{"localvar":"my","containerName":"get_subtotal","definition":"my","line":35,"name":"$self","kind":13},{"name":"$self","containerName":"get_subtotal","line":36,"kind":13}],"kind":12},{"kind":12,"line":36,"name":"subtotal"},{"kind":12,"children":[{"containerName":"_calculate_subtotal","localvar":"my","line":40,"definition":"my","name":"$self","kind":13},{"kind":13,"name":"$basket_item","definition":"my","line":42,"localvar":"my","containerName":"_calculate_subtotal"},{"name":"$self","containerName":"_calculate_subtotal","line":42,"kind":13}],"signature":{"label":"_calculate_subtotal($self)","documentation":"","parameters":[{"label":"$self"}]},"name":"_calculate_subtotal","detail":"($self)","range":{"end":{"line":42,"character":9999},"start":{"line":39,"character":0}},"line":39,"definition":"sub","containerName":"main::"},{"name":"basket","line":42,"kind":12},{"definition":"my","line":44,"localvar":"my","containerName":null,"kind":13,"name":"$product"},{"containerName":null,"name":"%self","line":44,"kind":13},{"name":"products","kind":12,"line":44},{"line":44,"kind":13,"name":"%basket_item","containerName":null},{"line":44,"kind":12,"name":"code"},{"line":46,"kind":13,"name":"%product","containerName":null}],"version":5}