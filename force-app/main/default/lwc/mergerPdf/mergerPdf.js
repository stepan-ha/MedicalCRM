import { LightningElement, api, track } from "lwc";
import pdflib from "@salesforce/resourceUrl/pdfLib";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MergerPDF extends LightningElement{
    @api filesToMerge = [];
    @track relatedFileWrappers = [];
    @track isLoading = false;
    @track droppedPdfs = [];
    mergedUrl;
    
    fileWrappersForMerging = [];

    async connectedCallback(){
        await loadScript(this, pdflib);
    }

    handleClickFileButton(event){
        let file = this.relatedFileWrappers.find((item) => item.id == event.target.name);
        file.selected = !file.selected;

        if(file.selected) {
            this.fileWrappersForMerging.push(file);
        }
        else{
            this.fileWrappersForMerging = this.fileWrappersForMerging.filter(item => item.id != file.id);
        }
    }

    handleShowTooltip(event){
        let tooltip = this.template.querySelector('div[data-id="' + event.target.name + '"]');

        tooltip.style.top = (event.clientY + 30) + 'px';
        tooltip.style.left = (event.clientX - 20) + 'px';
    }

    handleCancelMerging(){
        this.relatedFileWrappers = [];
        this.fileWrappersForMerging = [];
    }

    async handleMergePdf() {
        const sourceList = this.droppedPdfs.length ? this.droppedPdfs : this.fileWrappersForMerging;
        if (sourceList.length < 1) return;
        this.isLoading = true;

        try{
            const pdfDoc = await PDFLib.PDFDocument.create();  
            for (let fileWrapper of sourceList) {
                let tempBytes = Uint8Array.from(atob(fileWrapper.base64String), (c) => c.charCodeAt(0));
                let currentPdf = await PDFLib.PDFDocument.load(tempBytes);
    
                for (let pageOfCurrentPDF of currentPdf.getPages()) {
                    let page = pdfDoc.addPage();
                    let currentPage = await pdfDoc.embedPage(pageOfCurrentPDF);
                    
                    let scalePDF = currentPage.scale(0.99);
                    let scalePage = currentPage.scale(0.95);
                    
                    page.drawPage(currentPage, {
                        ...scalePage,
                        x: page.getWidth() - scalePDF.width,
                        y: page.getHeight() - scalePDF.height - 10,
                    });
                }
            }
            
            let pdfBytes = await pdfDoc.save();
            const blob = new Blob([pdfBytes], { type: 'application/pdf' });
            this.mergedUrl = URL.createObjectURL(blob);
            this._lastMergedBlob = blob;
        }
        catch(e){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error while merging PDF',
                message: 'Error: ' + e.message,
                variant: 'error',
            }));
        }

        this.relatedFileWrappers.forEach(item => item.selected = false);
        this.isLoading = false;
    }

    saveMergedPDF(pdfName, byte) {
        let blob = new Blob([byte], { type: "application/pdf" });
        let link = document.createElement("a");

        link.href = window.URL.createObjectURL(blob);
        link.download = pdfName;
        link.click();
    }

    get areFilesLoaded() {
        return this.relatedFileWrappers.length > 0;
    }

    get sizeForFileLayout(){
        return 12 / this.countOfIconsInRow
    }

    get cardTitle() {
        return this.mainTitle ? this.mainTitle : 'Merge PDF Files';
    }

    get mergeTitle(){
        return this.mergeButtonTitle ? this.mergeButtonTitle : 'Merge';
    }

    get isMergeDisabled(){
        return !(this.droppedPdfs && this.droppedPdfs.length >= 2);
    }

    handleDragOver(event){
        event.preventDefault();
    }

    async handleDrop(event){
        console.log("Drop!");
        event.preventDefault();
        try{
            const data = event.dataTransfer.getData('application/json');
            if(!data) return;
            const parsed = JSON.parse(data);
            if(parsed.type !== 'pdf-list' || !parsed.items) return;
            await this.addPdfs(parsed.items);
        }catch(e){ /* no-op */ }
    }

    @api async addPdfs(items){
        // items: [{id, name, downloadUrl}]
        const toAdd = [];
        for(const it of items){
            if(this.droppedPdfs.some(p=>p.id===it.id)) continue;
            let base64String;
            if(it.base64String){
                base64String = it.base64String;
            } else if(it.downloadUrl){
                try{
                    const resp = await fetch(it.downloadUrl);
                    const buf = await resp.arrayBuffer();
                    base64String = this.arrayBufferToBase64(buf);
                }catch(e){
                    continue;
                }
            } else {
                continue;
            }
            toAdd.push({ id: it.id, name: it.name, base64String });
        }
        this.droppedPdfs = [...this.droppedPdfs, ...toAdd];
    }

    arrayBufferToBase64(buffer){
        let binary = '';
        const bytes = new Uint8Array(buffer);
        const len = bytes.byteLength;
        for (let i = 0; i < len; i++) {
            binary += String.fromCharCode(bytes[i]);
        }
        return btoa(binary);
    }

    openFileDialog(){
        const input = this.template.querySelector('input[type="file"]');
        if(input){ input.value = ''; input.click(); }
    }

    async handleLocalUpload(event){
        const files = Array.from(event.target.files || []);
        console.log('files: ', files);
        const results = await Promise.all(files.map(f=>this.readFileAsBase64(f)));
        console.log('results: ', results);
        const items = results.map((base64String, idx)=>({ id: `local-${Date.now()}-${idx}`, name: files[idx].name, base64String }));
        console.log('items: ', JSON.stringify(items));
        this.droppedPdfs = [...this.droppedPdfs, ...items];
    }

    readFileAsBase64(file){
        return new Promise((resolve, reject)=>{
            const reader = new FileReader();
            reader.onload = ()=>{
                const res = reader.result;
                const base64 = typeof res === 'string' ? res.split(',')[1] : '';
                resolve(base64);
            };
            reader.onerror = reject;
            reader.readAsDataURL(file);
        });
    }

    handleRemove(event){
        const idx = Number(event.currentTarget.dataset.index);
        if(Number.isFinite(idx)){
            this.droppedPdfs = this.droppedPdfs.filter((_,i)=>i!==idx);
        }
    }

    handleClear(){
        this.droppedPdfs = [];
        this.mergedUrl = undefined;
        this._lastMergedBlob = undefined;
    }

    async handlePreview(){
        if(!this.mergedUrl){
            await this.handleMergePdf();
        }
        if(this.mergedUrl){
            try{
                window.open(this.mergedUrl, '_blank');
            }catch(e){
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Preview blocked',
                    message: 'Unable to open preview in a new tab.',
                    variant: 'warning',
                }));
            }
        }
    }

    handleDownloadMerged(){
        if(!this._lastMergedBlob) return;
        this.saveMergedPDF(this.fileName || 'merged.pdf', this._lastMergedBlob);
    }

    saveMergedPDF(pdfName, blob) {
        const link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = pdfName || 'merged.pdf';
        link.click();
    }

    // Reorder by drag within list
    handleRowDragStart(event){
        event.dataTransfer.setData('text/plain', String(event.currentTarget.dataset.index));
    }
    handleRowDragOver(event){
        event.preventDefault();
    }
    handleRowDrop(event){
        event.preventDefault();
        const fromIdx = Number(event.dataTransfer.getData('text/plain'));
        const toIdx = Number(event.currentTarget.dataset.index);
        if(!Number.isFinite(fromIdx) || !Number.isFinite(toIdx) || fromIdx===toIdx) return;
        const arr = [...this.droppedPdfs];
        const [moved] = arr.splice(fromIdx, 1);
        arr.splice(toIdx, 0, moved);
        this.droppedPdfs = arr;
    }
}