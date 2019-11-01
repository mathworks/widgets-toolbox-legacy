/*
 * Copyright (c) 2011-2018, The MathWorks, Inc.<consulting@mathworks.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

package com.mathworks.consulting.widgets.tree;

import java.awt.datatransfer.*;
import java.util.*;
import javax.swing.*;
import javax.swing.tree.*;

public class TreeTransferHandler extends TransferHandler {

    DataFlavor nodesFlavor;
    DataFlavor[] flavors = new DataFlavor[1];

    public TreeTransferHandler() throws ClassNotFoundException {
        String mimeType;
        mimeType = DataFlavor.javaJVMLocalObjectMimeType + ";class=\""
                + javax.swing.tree.DefaultMutableTreeNode[].class.getName() + "\"";
        nodesFlavor = new DataFlavor(mimeType);
        flavors[0] = nodesFlavor;
    }

    @Override
    protected Transferable createTransferable(JComponent c) {
        JTree tree = (JTree) c;
        TreePath[] paths = tree.getSelectionPaths();
        if (paths != null) {
            // Make up a node array for transfer
            List<TreeNode> nodeList =
                    new ArrayList<TreeNode>();
            TreeNode node =
                    (TreeNode) paths[0].getLastPathComponent();
            nodeList.add(node);
            for (int i = 1; i < paths.length; i++) {
                TreeNode next =
                        (TreeNode) paths[i].getLastPathComponent();
                // Do not allow higher level nodes to be added to list.  
                if (next.getLevel() < node.getLevel()) {
                    break;
                } else if (next.getLevel() > node.getLevel()) {  // child node  
                    nodeList.add(next);
                    // node already contains child  
                } else {                                        // sibling  
                    nodeList.add(next);
                }
            }
            TreeNode[] nodes =
                    nodeList.toArray(new TreeNode[nodeList.size()]);
            return new NodesTransferable(nodes);
        }
        return null;
    }

    @Override
    public int getSourceActions(JComponent c) {
        return COPY_OR_MOVE;
    }

    public class NodesTransferable implements Transferable {

        TreeNode[] nodes;

        public NodesTransferable(TreeNode[] nodes) {
            this.nodes = nodes;
        }

        @Override
        public Object getTransferData(DataFlavor flavor) throws UnsupportedFlavorException {
            if (!isDataFlavorSupported(flavor)) {
                throw new UnsupportedFlavorException(flavor);
            }
            return nodes;
        }

        @Override
        public DataFlavor[] getTransferDataFlavors() {
            return flavors;
        }

        @Override
        public boolean isDataFlavorSupported(DataFlavor flavor) {
            return nodesFlavor.equals(flavor);
        }
    }
}
