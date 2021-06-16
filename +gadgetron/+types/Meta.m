classdef Meta
    
    methods (Access = public, Static)
        
        function meta = from_string(str)

            meta = containers.Map();  
            
            if ~strlength(deblank(str)), return; end

            db = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
            isrc = org.xml.sax.InputSource();
            isrc.setCharacterStream(java.io.StringReader(deblank(str)))

            try
                dom = db.parse(isrc);
            catch ME
                message = "Parsing image attribute_string failed with the following error: " + string(ME.ExceptionObject.getMessage());
                warning('gadgetron:types:image:meta:failedToParseAttributeString', message);
                return
            end

            entries = dom.getElementsByTagName("meta");

            for index = 0:entries.getLength()-1               

                name = []; values = string.empty;

                current = entries.item(index).getFirstChild();
                while ~isempty(current)

                    if current.getNodeType() == 1

                        text = char(current.getTextContent());
                        switch char(current.getNodeName())
                            case 'name'
                                name = text;
                            case 'value'
                                values(end + 1) = string(text); %#ok<AGROW>
                        end
                    end

                    current = current.getNextSibling();
                end                

                if ~isempty(name)                    
                    meta(name) = values;
                end
            end
        end
        
        function str = to_string(meta)
            
            if isempty(meta), str = ''; return; end
            
            db = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
            document = db.newDocument();
            
            ismrmrdMeta = document.createElement('ismrmrdMeta');
            
            document.appendChild(ismrmrdMeta);
            
            for key = meta.keys(), key = key{:}; % Cell Arrays...
                
                meta_node = document.createElement('meta');

                name_node = document.createElement('name');
                name_text = document.createTextNode(key);

                name_node.appendChild(name_text); meta_node.appendChild(name_node);
                
                for val = meta(key)
                    
                    value_node = document.createElement('value');
                    value_text = document.createTextNode(val);
            
                    value_node.appendChild(value_text); meta_node.appendChild(value_node);
                end                
                
                ismrmrdMeta.appendChild(meta_node);                                
            end            
            
            transformer = javax.xml.transform.TransformerFactory.newInstance().newTransformer();
            result = javax.xml.transform.stream.StreamResult(java.io.StringWriter());
            source = javax.xml.transform.dom.DOMSource(document);
            
            transformer.transform(source, result);
            
            str = char(result.getWriter().toString());
        end       
    end
end


