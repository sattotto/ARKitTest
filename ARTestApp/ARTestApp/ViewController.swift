//
//  ViewController.swift
//  ARTestApp
//
//  Created by satoto on 2018/01/15.
//  Copyright © 2018年 佐藤秀輔. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var memoText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func createMemo(_ sender: Any) {
        //setMemoToScene(memo: "hoge")
        self.performSegue(withIdentifier: "create", sender: nil)
    }
    
    private func createMemoNode(_ memo:String, position:SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        
        let memoView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        memoView.backgroundColor = UIColor.clear
        
        let memoLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        memoLabel.text = memo
        memoLabel.textColor = UIColor.black
        memoLabel.font = UIFont.systemFont(ofSize: 24)
        memoView.addSubview(memoLabel)
        
        let geometry = SCNBox(width: memoView.frame.width * scale / memoView.frame.height, height: scale, length: 0.00000001, chamferRadius: 0.0)
        geometry.firstMaterial?.diffuse.contents = memoView
        node.geometry = geometry
        node.position = position
        return node
    }
    
    private func setMemoToScene(memo: String){
        if let camera = sceneView.pointOfView {
            let position = SCNVector3(0, 0, -5)
            let convertPosition = camera.convertPosition(position, to: nil)
            let node = createMemoNode(memo, position: convertPosition)
            node.eulerAngles = camera.eulerAngles
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func unwindToFirstView(segue: UIStoryboardSegue) {
        setMemoToScene(memo: memoText!)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

}
